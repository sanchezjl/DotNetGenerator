package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Action
import co.edu.javeriana.isml.isml.ActionCall
import co.edu.javeriana.isml.isml.Controller
import co.edu.javeriana.isml.isml.Entity
import co.edu.javeriana.isml.isml.For
import co.edu.javeriana.isml.isml.ForView
import co.edu.javeriana.isml.isml.If
import co.edu.javeriana.isml.isml.MethodStatement
import co.edu.javeriana.isml.isml.Parameter
import co.edu.javeriana.isml.isml.Return
import co.edu.javeriana.isml.isml.Show
import co.edu.javeriana.isml.isml.Type
import co.edu.javeriana.isml.isml.VariableReference
import co.edu.javeriana.isml.isml.ViewInstance
import co.edu.javeriana.isml.isml.While
import co.edu.javeriana.isml.scoping.IsmlModelNavigation
import com.google.inject.Inject
import java.util.ArrayList
import java.util.HashMap
import java.util.List
import java.util.Map
import org.eclipse.emf.common.util.EList
import co.edu.javeriana.dotnetgenerator.utils.UtilGenerator
import co.edu.javeriana.isml.isml.MethodCall
import co.edu.javeriana.isml.isml.ResourceReference
import co.edu.javeriana.isml.isml.Variable
import co.edu.javeriana.isml.isml.Attribute
import co.edu.javeriana.isml.isml.Assignment
import co.edu.javeriana.isml.isml.ParameterizedType
import co.edu.javeriana.isml.isml.TypeSpecification
import co.edu.javeriana.isml.isml.Primitive
import co.edu.javeriana.isml.isml.StructInstance
import co.edu.javeriana.isml.isml.StringValue
import co.edu.javeriana.isml.isml.impl.IntValueImpl
import co.edu.javeriana.isml.isml.BinaryOperator
import co.edu.javeriana.isml.isml.Service

class ControllerTemplate extends SimpleTemplate<Controller> {
	
	/*Inyección de las clases auxiliares con metodos utilitarios*/
	@Inject extension IsmlModelNavigation
	@Inject extension UtilGenerator	
	@Inject extension ExpressionTemplate
	
	var EList<Entity> controllerEntities
	var Entity entityToList
	var Map<String, Type> neededAttributes = new HashMap
	
	/**
	 * Metodo para precargar los atributos y dependencias necesarias
	 * para el controlador
	 *
	 */
	override preprocess(Controller controller) {
		var Map<String, Object> neededData = controller.getNeededAttributes
		controllerEntities = neededData.get("controllerEntities") as EList<Entity>
		entityToList = neededData.get("entityToList") as Entity
		neededAttributes = neededData.get("neededAttributes") as Map<String, Type>
		val controlledPages = controller.controlledPages
		val forViews = new ArrayList<ForView>()
		for (p : controlledPages) {
			forViews.addAll(p.eAllContents.filter(ForView).toIterable)
		}
		for (p : forViews) {
			val key = p.variable.name
			val value = p.variable.type
			println(key + "->" + value)
			neededAttributes.put(key, value)
		}
	}		

	/**
	 * This method generates the whole C# Controller archive from a given ISML controller.
	 * @param c the Controller
	 * @return the Controller archive
	 * */
	override def CharSequence template(Controller c) '''
	using System.Web.Mvc;
	using AplicacionWeb.Models;
	using AplicacionWeb.DAL;
	using AplicacionWeb.Services;
	
	namespace AplicacionWeb.Controllers
	{
		public class «c.name» : Controller
		{
			«FOR attr: c.body.filter(Attribute)»
				«generateAttributes(attr)»
			«ENDFOR»
			
			public «c.name»(«FOR attr: c.body.filter(Attribute) SEPARATOR ', '»«IF attr.type instanceof ParameterizedType »«IF getCollectionString(attr.type as ParameterizedType).equals("Persistence") || attr.type.typeSpecification instanceof Service»I«ENDIF»«getCollectionString(attr.type as ParameterizedType)»<«(attr.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»> _«attr.name»«ELSE»«IF attr.type.typeSpecification instanceof Service»I«ENDIF»«attr.type.typeSpecification.name» _«attr.name»«ENDIF»«ENDFOR»)
			{
				«FOR attr: c.body.filter(Attribute)»
					«attr.name» = _«attr.name»;
				«ENDFOR»
			}
			
			«FOR func: c.actions»
				«generateFunction(func)»
				
			«ENDFOR»
			
		}
	}
	'''
	
	/**
	 * This method generates an Attribute declaration in C#.
	 * @param attribute attribute in ISML
	 * @return attribute in C# format
	 * */
	def generateAttributes(Attribute attribute)'''
		«IF attribute.type instanceof ParameterizedType »
			private «IF getCollectionString(attribute.type as ParameterizedType).equals("Persistence") || attribute.type.typeSpecification instanceof Service»I«ENDIF»«getCollectionString(attribute.type as ParameterizedType)»<«(attribute.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»> «attribute.name»;
		«ELSE»
			private «IF attribute.type.typeSpecification instanceof Service»I«ENDIF»«attribute.type.typeSpecification.name» «attribute.name»;
		«ENDIF»		
	''' 
	/**
	 * This method generates the C# code for a function, from the given ISML action.
	 * @param action the ISML action
	 * @return the C# function
	 * */
	def CharSequence generateFunction(Action action)'''
		«IF action.parameters.size==1 && action.parameters.get(0).type.typeSpecification instanceof Entity»[HttpPost]«ENDIF»
		public ActionResult «action.name.toFirstUpper»(«getParameters(action)»)
		{
			«generateBody(action.body)»
		}
	'''
	
	/**
	 * This method generates the body of a C# function, given a ISML MethodStatement list.
	 * @param lms the ISML action list
	 * @return C# function body
	 * */
	def CharSequence generateBody(List<MethodStatement> lms)'''
		«FOR sentence: lms»«IF sentence instanceof If || sentence instanceof For»«generateMethodStatement(sentence)»«ELSE»«generateMethodStatement(sentence)»; 
		«ENDIF»«ENDFOR»
	'''
	
	/**
	 * This method generates the C# "if" statement, given a ISML If statement.
	 * @param ifst the ISML If statement
	 * @return C# if statement
	 * */
	def dispatch CharSequence generateMethodStatement(If ifst)'''
		if(«generateMethodStatement(ifst.condition)»){
			«generateBody(ifst.body)»
		}
		«IF ifst.elseBody?.size>0»
		else{
			«ifst.elseBody.generateBody»
		}
		«ENDIF»
	'''

	/**
	 * This method must generate the C# Assignment statement, given the ISML assignment statement.
	 * @param assign the ISML assignment
	 * @return the C# Assignment statement
	 * */
	def dispatch CharSequence generateMethodStatement(Assignment assign){
		return '''«generateMethodStatement(assign.left)» «writeSymbol(assign.symbol)» «generateMethodStatement(assign.right)»'''
	}
	
	
	/**
	 * This method must generate the C# Return statement, given the ISML return statement.
	 * @param returnst the ISML return
	 * @return the C# Return statement
	 * */
	def dispatch CharSequence generateMethodStatement(Return returnst){
		return ''''''
	}
	
	/**
	 * This method generates the C# "for" statement, given a ISML For statement.
	 * @param forst the ISML For statement
	 * @return C# for statement
	 * */
	def dispatch CharSequence generateMethodStatement(For forst)'''
		foreach(var «forst.variable.name» in «forst.collection.valueTemplate»)
		{
			«generateBody(forst.body)»
		}
	'''
	
	/**
	 * This method must generate the C# "while" statement, given a ISML While statement.
	 * @param whilest the ISML While statement
	 * @return C# while statement
	 * */
	def dispatch CharSequence generateMethodStatement(While whilest){
		return ''''''
	}
	
	/**
	 * This method generates the C# action calling, given a ISML ActionCall statement.
	 * @param acst the ISML ActionCall statement
	 * @return C# action calling
	 * */
	def dispatch CharSequence generateMethodStatement(ActionCall call)'''
	return RedirectToAction("«call.action.name.toFirstUpper»"«generateControllerNameParameterActionCall(call)»«generateParametersActionCall(call)»)'''
	
	/**
	 * This method generates the controller name if this is diferent to controller actual
	 * @param acst the ISML ActionCall statement
	 * @return C# action calling
	 * */
	def CharSequence generateControllerNameParameterActionCall(ActionCall call) 
	'''«IF call.controllerIfExists.name != call.action.controllerIfExists.name», "«call.action.controllerIfExists.name.replace("Controller","")»"«ENDIF»'''	
	
	/**
	 * This method generates formatted parameters for an action, given a ISML Action<br> 
	 * statement.
	 * @param action the ISML Action statement
	 * @return formatted parameters, separated by commas
	 * */
	def CharSequence generateParametersActionCall(ActionCall call) 
	'''«IF call.action.parameters.size !=0», new { «FOR i: 0..<call.action.parameters.size SEPARATOR ','»«call.action.parameters.get(i).name » = «call.parameters.get(i).valueTemplate»«ENDFOR» }«ENDIF»'''	
	
	/**
	 * This method must generate the  C#  method calling, given a ISML MethodCall statement.
	 * @param mcst the ISML MethodCall statement
	 * @return C# for statement
	 * */
	def dispatch CharSequence generateMethodStatement(MethodCall mcst){
		return ''''''
	}
	
	/**
	 * This method must generate the C# resource referencing, given a ISML<br> 
	 * ResourceReference statement.
	 * @param resref the ISML ResourceReference statement
	 * @return C# resource referencing
	 * */
	def dispatch CharSequence generateMethodStatement(ResourceReference resref){
		return ''''''
	}
	
	/**
	 * This method must generate the C# type, given a ISML Type statement.
	 * @param type the ISML Type statement
	 * @return C# type statement
	 * */
	def dispatch CharSequence generateMethodStatement(Type type){
		return ''''''
	}
	
	/**
	 * This method generates the C# variable reference, given a ISML VariableReference<br> 
	 * statement.
	 * @param vr the ISML VariableReference statement
	 * @return C# variable reference
	 * */
	def dispatch CharSequence generateMethodStatement(VariableReference vr)'''
		«vr.valueTemplate»'''
		
	/**
	 * This method generates the C# variable declaration, given a ISML Variable<br> 
	 * statement.
	 * @param variable the ISML Variable statement
	 * @return C# variable
	 * */
	def dispatch CharSequence generateMethodStatement(Variable variable){
		val tipo=variable.value;
		'''«IF variable.type instanceof ParameterizedType »var «variable.name» «IF(tipo instanceof StructInstance)»«generateMethodStatement(tipo)»«ELSEIF (tipo instanceof VariableReference)»= «generateMethodStatement(tipo)»«ENDIF»«ELSE»«generateType(variable.type.typeSpecification.name)» «variable.name»«IF(tipo!=null && tipo instanceof StringValue)»=«variable.getValue.getValue»«ELSEIF(tipo!=null && variable.getValue instanceof VariableReference)»= «generateMethodStatement(tipo)»«ELSEIF(tipo instanceof BinaryOperator)»=«generateMethodStatement(tipo)»«ELSEIF(tipo instanceof StructInstance)»«generateMethodStatement(tipo)»«ELSEIF(tipo instanceof IntValueImpl)»=«generateMethodStatement(tipo)»«ELSE»«tipo.toString»«ENDIF»«ENDIF»'''
	}	
	
	def dispatch CharSequence generateMethodStatement(StructInstance expression) '''= new «IF expression.type instanceof ParameterizedType »«getCollectionString(expression.type as ParameterizedType)»<«(expression.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»>«ELSE»«expression.type.typeSpecification.name»«ENDIF»()'''
	
	def dispatch CharSequence generateMethodStatement(IntValueImpl expresion)'''«expresion.literal»'''
	

	def dispatch CharSequence generateMethodStatement(BinaryOperator expression) '''«generateMethodStatement(expression.left)» «writeSymbol(expression.symbol)» «generateMethodStatement(expression.right)»'''
	
	def dispatch CharSequence generateMethodStatement(StringValue expression) '''«expression.getValue»'''
	
	/**
	 * This method generates a return method for show views in C#, given a ISML Show<br> 
	 * statement.
	 * @param show the ISML Show statement
	 * @return C# return method for show
	 * */
	def dispatch generateMethodStatement(Show show){
		val expression = show.expression
		switch(expression){
			ViewInstance:'''
			«generateViewBagParameters(expression)»
			return View(«generateViewParameters(expression)»)'''
			default:''''''
		}
	}
	
	def CharSequence generateViewBagParameters(ViewInstance instance){		
		var accumulate= ""
		var string= ""
		for(i : 0..<instance.parameters.size){			
			
			if(i>0 && instance.parameters.get(i) instanceof VariableReference 
				&&  instance.parameters.get(i).cast(VariableReference).referencedElement instanceof Variable)
			{
				var nombre =valueTemplate(instance.parameters.get(i));
				accumulate += ("ViewBag."+ nombre + "=" + nombre + ";")				
			}	
		}
		string= accumulate
		return string
	} 
	
	def CharSequence generateViewParameters(ViewInstance instance){		
		var accumulate= ""
		var string= ""
		if(instance.parameters.size>0)
		{
			accumulate += valueTemplate(instance.parameters.get(0))
		}		
		string= accumulate
		return string
	}	
	
	/**
	 * This method generates formatted parameters for an action, given a ISML Action<br> 
	 * statement.
	 * @param action the ISML Action statement
	 * @return formatted parameters, separated by commas
	 * */
	def CharSequence getParameters(Action action) '''«IF action.parameters.size !=0»«FOR param: action.parameters SEPARATOR ','»«generateParams(param)»«ENDFOR»«ELSE»«ENDIF»'''
	
	
	/**
	 * This method generates format for the parameter given, distinguishing between Entity parameters <br>
	 * and other parameter types.
	 *  
	 * @param action the ISML Action statement
	 * @return formatted parameters, separated by commas
	 * */
	def CharSequence generateParams(Parameter p){
		return '''«getTypeSpecificationString(p.type.typeSpecification)» «p.name»'''
	}	
	
	
	def String getTypeSpecificationString(TypeSpecification specification) {		
		switch specification{
			case specification instanceof Primitive && specification.name.equalsIgnoreCase("Integer"): return "int" 
			case specification instanceof Primitive && specification.name.equalsIgnoreCase("BytesArray"): return "String"
			case specification instanceof Primitive && specification.name.equalsIgnoreCase("Any"): return "Object"
			default: return specification.name
		}
	}	
	
}
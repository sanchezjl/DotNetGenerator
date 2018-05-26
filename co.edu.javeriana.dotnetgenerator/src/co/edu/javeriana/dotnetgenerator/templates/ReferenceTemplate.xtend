package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.isml.Action
import co.edu.javeriana.isml.isml.ActionCall
import co.edu.javeriana.isml.isml.Controller
import co.edu.javeriana.isml.isml.Entity
import co.edu.javeriana.isml.isml.GenericTypeSpecification
import co.edu.javeriana.isml.isml.MethodCall
import co.edu.javeriana.isml.isml.Parameter
import co.edu.javeriana.isml.isml.ParameterizedType
import co.edu.javeriana.isml.isml.Reference
import co.edu.javeriana.isml.isml.ResourceReference
import co.edu.javeriana.isml.isml.Show
import co.edu.javeriana.isml.isml.Type
import co.edu.javeriana.isml.isml.TypeSpecification
import co.edu.javeriana.isml.isml.VariableReference
import co.edu.javeriana.isml.isml.ViewInstance
import co.edu.javeriana.isml.scoping.IsmlModelNavigation
import java.util.Map
import javax.inject.Inject
import org.eclipse.emf.common.util.BasicEList
import org.eclipse.emf.common.util.EList
import org.eclipse.emf.ecore.EObject


/**
 * 
 * Clase para utilidades de las plantillas
 * 
 */
class ReferenceTemplate {
	@Inject extension IsmlModelNavigation
	@Inject extension ExpressionTemplate

/**
 * 
 * 
 */
	def dispatch CharSequence writeReference(MethodCall reference) '''		
		«reference.method.name»(«FOR parameter : reference.parameters SEPARATOR ','»«writeExpression(parameter)»«ENDFOR»)'''



	def dispatch CharSequence writeReference(ActionCall reference) '''		
		«IF reference.findAncestor(Controller) != null
			»return «ENDIF»«IF !(reference.action.eContainer as Controller).name.equals((reference.findAncestor(Controller)as Controller).name)»«(reference.action.eContainer as Controller).name.toFirstLower».«ENDIF»«reference.
			action.name»(«FOR parameter : validateParameterForActionCall(reference) SEPARATOR ','»«writeExpression(parameter)»«ENDFOR»)'''

	def dispatch CharSequence writeReference(ResourceReference reference) ''''''
	
	def ViewInstance getViewInstanceIfExists(EObject object){
		var EObject returnObject=null
		var tmpObject=object
		while(tmpObject!=null && returnObject==null){
			if(tmpObject.eContainer!=null && tmpObject.eContainer instanceof ViewInstance && tmpObject.eContainer.eContainer!=null && !(tmpObject.eContainer.eContainer instanceof Show)){
				returnObject=tmpObject.eContainer
			}
			tmpObject=tmpObject.eContainer
		}
		return returnObject as ViewInstance
	}
	
	
	def dispatch CharSequence writeReference(VariableReference reference) {
		var str = ""
			str = reference.tail.referencedElement.name
		return str
	}
	
		
	def dispatch CharSequence writeReference(Type reference){
		var String text
		if(reference.referencedElement instanceof Entity && reference.tail==null){
			text=reference.referencedElement.name.toFirstUpper
		} else{
			text=reference.referencedElement.name.toFirstUpper
			if (reference.tail!=null){
				text+="."+writeReference(reference.tail)
			}
		}
		
		return text
	}		
	
	
	def evaluateReference(Reference parameter) {
		var pass = true
		if (parameter.referencedElement instanceof Parameter) {
			if (getActionIfExists(parameter)!=null) {
				var controller = parameter.eContainer.controllerIfExists
				var attributesMap = controller.neededAttributes.get("neededAttributes") as Map<String,Type>
				if (attributesMap.containsKey((parameter.referencedElement as Parameter).name) && parameter.tail == null ) {
					pass = false
				}
			}
		}
		return pass
	}
	
	def getActionIfExists(EObject o){
		var Action a=null
		var EObject tmp=o
		while(tmp != null && a==null){
			if(tmp.eContainer!=null && tmp.eContainer instanceof Action){
				a=tmp.eContainer as Action
			}
			tmp=tmp.eContainer
		}
		return a
	}
	
	def EList<Object> evaluateToCastShowParameter(Parameter param,Reference reference){
		var doCast=false
		var neededAttributes=getNeededAttributes(reference.findAncestor(Controller)as Controller).get("neededAttributes")as Map<String,Type>
		var tailType=reference.tailType
		var EList<Object> returnData=new BasicEList
		var castText=""
		doCast=!tailType.isDescendentOf(param.type.typeSpecification)&&!tailType.typeSpecification.typeSpecificationString.equalsIgnoreCase((neededAttributes).get(param.name).typeSpecification.typeSpecificationString)
		if(doCast){
			if(tailType instanceof ParameterizedType && neededAttributes.get(param.name) instanceof ParameterizedType){
				doCast=!(tailType as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString.equalsIgnoreCase((neededAttributes.get(param.name)as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString)
				if(doCast){
					castText=tailType.writeType(false);
				}
			}
		}
		if(doCast && castText.equals("")){
			if(tailType.typeSpecification instanceof GenericTypeSpecification){
				doCast=false;
			}else{				
				castText=tailType.writeType(true)	
			}
			
		}		
		returnData.add(doCast)
		returnData.add(castText)
		return returnData
	}
	
	def boolean isDescendentOf(Type type,TypeSpecification ts){
		for(superType:type.typeSpecification.superTypes){
			if(superType.typeSpecification.name.equalsIgnoreCase(ts.name)){
				return true;
			}
		}
		return false;
	}
}
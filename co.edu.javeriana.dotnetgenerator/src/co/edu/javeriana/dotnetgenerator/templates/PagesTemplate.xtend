package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.generator.common.SimpleTemplate
import com.google.inject.Inject
import co.edu.javeriana.isml.validation.TypeChecker
import co.edu.javeriana.isml.scoping.IsmlModelNavigation
import co.edu.javeriana.isml.isml.ViewInstance
import co.edu.javeriana.isml.isml.Page
import org.eclipse.emf.common.util.EList
import co.edu.javeriana.isml.isml.ViewStatement
import co.edu.javeriana.isml.isml.ForView
import co.edu.javeriana.isml.isml.NamedViewBlock
import co.edu.javeriana.isml.isml.Reference
import co.edu.javeriana.isml.isml.VariableReference
import java.util.Map
import co.edu.javeriana.isml.isml.Expression
import java.util.HashMap
import co.edu.javeriana.isml.isml.ResourceReference
import java.util.LinkedHashMap
import java.util.ArrayList
import co.edu.javeriana.isml.isml.Entity
import co.edu.javeriana.dotnetgenerator.utils.UtilGenerator
import co.edu.javeriana.isml.isml.ParameterizedType
import co.edu.javeriana.isml.isml.Parameter
import co.edu.javeriana.isml.isml.BoolValue
import co.edu.javeriana.isml.isml.FloatValue
import co.edu.javeriana.isml.isml.IntValue
import co.edu.javeriana.isml.isml.NullValue
import co.edu.javeriana.isml.isml.StringValue
import co.edu.javeriana.isml.isml.MethodCall
import java.util.List
import co.edu.javeriana.isml.isml.ActionCall
import co.edu.javeriana.isml.isml.StructInstance
import org.eclipse.xtext.naming.IQualifiedNameProvider

class PagesTemplate extends SimpleTemplate<Page> {
	
	@Inject extension TypeChecker
	@Inject extension IsmlModelNavigation	
	@Inject extension ExpressionTemplate
	@Inject extension ReferenceTemplate
	@Inject extension UtilGenerator	
	@Inject extension IQualifiedNameProvider
	
	Map<ViewInstance,String> forms
	int i;
	int j;
	String modelname = "";
	Parameter model;
	
	String pagename = "";
	String titlepage = "";	
	List<String> listViewBag;
	List<String> listCalendar;
		
	
	override preprocess(Page e) {
		i = 1;
		pagename=e.name;
		getDataModel(e);	
		forms=new HashMap
	}	
	
	/**
     * Método que retorna la pagina HTML de la Vista
     */
	override def CharSequence template(Page page) '''
	«generateHeader()»
	
	«IF page.body != null»
	«widgetTemplate(page.body)»
	«scriptsTemplate()»
	«ENDIF»	
	'''
	
	/**
     * Método encargado de obtener los datos del modelo recibido como parametro
     */	
	def getDataModel(Page page)
	{	
		listViewBag = new ArrayList<String>();
		listCalendar = new ArrayList<String>();
		
		if (page.parameters.size>0) 
		{			
			//Se obtiene el modelo a partir del primer paramentro
			modelname=page.parameters.get(0).name;
			model=page.parameters.get(0);
			if(page.parameters.size>1)
			{
				//Se obtiene el listado de ViewBags a partir de los demas parametros
				for(i : 1..<page.parameters.size){
					listViewBag.add(page.parameters.get(i).name);								
				}		
			} 
		}
	}
	
	/**
	 * This method generates an Attribute declaration in C#.
	 * @param attribute attribute in ISML
	 * @return attribute in C# format
	 * */
	def generateHeader()'''
		«IF model!==null »
		«IF model.type instanceof ParameterizedType »
			@model IEnumerable<AplicacionWeb.Models.«(model.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»>
		«ELSE»
			@model AplicacionWeb.Models.«model.type.typeSpecification.name»
		«ENDIF»
		«ENDIF»
	'''	
	
	def dispatch CharSequence widgetTemplate(ViewInstance viewInstance) {
	
		switch (viewInstance.type.typeSpecification.typeSpecificationString) {
		
			case "Panel": panel(viewInstance)
			case "Form": form(viewInstance)
			case "Text": inputText(viewInstance)
			case "Image": image(viewInstance)
			case "Password": password(viewInstance)
			case "Link": link(viewInstance)
			case "Spinner": spinner(viewInstance)
			case "ComboChooser": comboChooser(viewInstance)
			case "RadioChooser": radioChooser(viewInstance)
			case "Calendar": calendar(viewInstance)
			case "Media": Media(viewInstance)
			case "Label": label(viewInstance)
			case "OutputText": OutputText(viewInstance)
			case "CheckBox": checkBox(viewInstance)
			case "Button": button(viewInstance)
			case "PanelButton": panelButton(viewInstance)
			case "DataTable": dataTable(viewInstance)				  
		}		
	}
	
	
	/**
	 * Método encargado de generar elementos de tipo panel
	 * 
	 */
	def CharSequence panel(ViewInstance viewInstance) '''
	«IF titlepage.equals("")»
	@{
		ViewBag.Title = "«viewInstance.parameters.get(0).writeExpression»";		
	}
	«{titlepage=viewInstance.parameters.get(0).writeExpression.toString; ""}»	
	«ENDIF»
	«IF viewInstance.parameters.get(0).writeExpression.toString.isEmpty==false»
	<h2>«viewInstance.parameters.get(0).writeExpression»</h2>		
	<br />
	«ENDIF»
	<div>
		«FOR partBlock : viewInstance.body»
		«widgetTemplate(partBlock)»
		«ENDFOR»
	</div>
	'''
	
	
	/**
	 * Método encargado de generar elementos de un formulario
	 * 
	 */
	def CharSequence form(ViewInstance viewInstance) '''
	@using (Html.BeginForm())
	{
		<div class="form-horizontal">
			«FOR partBlock : viewInstance.getBody»
			«widgetTemplate(partBlock)»
			«ENDFOR»
		</div>
	}
	'''	
	
	/**
	 * Método encargado de generar elementos de tipo caja de texto
	 * 
	 */
	def CharSequence inputText(ViewInstance part) '''		
		<div class="form-group">
			«IF (part.parameters.get(0) instanceof NullValue)==false»«IF part.parameters.get(0) instanceof VariableReference»@Html.Label("@«generateVariableReference(part.parameters.get(0).cast(VariableReference))»", htmlAttributes: new { @class = "control-label col-md-2" })«ELSE»<label class="control-label col-md-2">«part.parameters.get(0).getValue»</label>«ENDIF»«ENDIF»
		    <div class="col-md-10">
				@Html.EditorFor(Model => «generateVariableReference(part.parameters.get(1).cast(VariableReference))», new { htmlAttributes = new { @class = "form-control" } })
			</div>
		</div>
	'''
	
	def CharSequence OutputText(ViewInstance part) '''	
		<div class="form-group">
			«IF part.parameters.get(0) instanceof VariableReference»@Html.Label("@«generateVariableReference(part.parameters.get(0).cast(VariableReference))»", htmlAttributes: new { @class = "control-label col-md-2" })«ELSE»<label class="control-label col-md-2">«part.parameters.get(0).getValue»</label>«ENDIF»
			<div class="col-md-10">
			«IF part.parameters.get(1) instanceof VariableReference»		
				«IF (part.parameters.get(1).cast(VariableReference)).referencedElement.name==modelname»	
				@Html.DisplayFor(model => «generateVariableReference(part.parameters.get(1).cast(VariableReference))»)
				«ELSE»
				@«generateVariableReference(part.parameters.get(1).cast(VariableReference))»
				«ENDIF»
			«ELSE»
				«part.parameters.get(1).getValue»
			«ENDIF»
			</div>
		</div>
	'''		
	
	/**
	 * Método encargado de generar elementos de tipo caja de contraseña
	 * 
	 */
	def CharSequence password(ViewInstance part) '''		
		<div class="form-group">
			@Html.LabelFor(Model => Model.«part.parameters.get(1).valueTemplate», htmlAttributes: new { @class = "control-label col-md-2" })
		    <div class="col-md-10">
				@Html.PasswordFor(Model => Model.«part.parameters.get(1).valueTemplate», new { htmlAttributes = new { @class = "form-control" } })
			</div>
		</div>
	'''	
	
	/**
	 * Método encargado de generar elementos de tipo spinner
	 * 
	 */
	def CharSequence spinner(ViewInstance part)'''
		<div class="form-group">
			<label class="control-label col-sm-2" for="«part.parameters.get(0).writeExpression»">«part.parameters.get(5).writeExpression»:</label>
			<input type="number"   
		       	   id="«part.parameters.get(0).writeExpression»"
		           name="«part.parameters.get(0).writeExpression»"
				   min="«part.parameters.get(3).writeExpression»"
				   max="«part.parameters.get(4).writeExpression»"
				   step="«part.parameters.get(2).writeExpression»"
				   ng-model="«part.parameters.get(1).writeExpression»" />
		</div>
	'''	
	
	/**
	 * Método encargado de generar elementos de tipo calendario
	 * 
	 */
	def CharSequence calendar(ViewInstance part) 
	{
		listCalendar.add(part.parameters.get(1).valueTemplate.toString().toFirstUpper);
	'''
		<div class="form-group">
			«IF (part.parameters.get(0) instanceof NullValue)==false»@Html.Label("«IF part.parameters.get(0) instanceof VariableReference»@«generateVariableReference(part.parameters.get(0).cast(VariableReference))»«ELSE»«part.parameters.get(0).getValue»«ENDIF»", htmlAttributes: new { @class = "control-label col-md-2" })«ENDIF»
		    <div class="col-md-10">
				@Html.EditorFor(Model => Model.«part.parameters.get(1).valueTemplate.toString.toFirstUpper», new { htmlAttributes = new { @class = "form-control" } })
			</div>
		</div>
	'''
	}

	/**
	 * Método encargado de generar elementos de tipo casilla de verificación CheckBoxFor
	 * 
	 */
	def CharSequence checkBox(ViewInstance part) '''
		<div class="form-group">
			«IF (part.parameters.get(0) instanceof NullValue)==false»@Html.Label("«IF part.parameters.get(0) instanceof VariableReference»@«generateVariableReference(part.parameters.get(0).cast(VariableReference))»«ELSE»«part.parameters.get(0).getValue»«ENDIF»", htmlAttributes: new { @class = "control-label col-md-2" })«ENDIF»
			<div class="col-md-10">
				@Html.CheckBoxFor(model => «generateVariableReference(part.parameters.get(1).cast(VariableReference))»)
			</div>
		</div>
	'''

	/**
	 * Método encargado de generar elementos de tipo lista despegable DropDownListFor
	 * Parametro 0: nombre del campo que se va a mostrar
	 * Parametro 1: listado con las opciones
	 * Parametro 2: atributo en el modelo
	 * Parametro 3: Opcion que se va a mostrar por defecto
	 *  
	 */
	def CharSequence comboChooser(ViewInstance part)'''    
		<div class="form-group">
			
			<div class="col-md-offset-2 col-md-10">
				@Html.DropDownListFor(model => «generateVariableReference(part.parameters.get(2).cast(VariableReference))», new SelectList(«generateVariableReference(part.parameters.get(1).cast(VariableReference))», "Id", "«part.parameters.get(0).writeExpression.toString.toFirstUpper»")«IF part.parameters.get(3) instanceof StringValue», "«part.parameters.get(3).writeExpression»"«ENDIF», new { @class = "form-control" } )
			</div>
		</div>
	'''	
		
	/**
	 * Método encargado de generar una lista de elementos de tipo radio botón RadioButtonFor
	 * Parametro 0: nombre del campo que se va a mostrar
	 * Parametro 1: listado con las opciones
	 * Parametro 2: atributo en el modelo
	 * Parametro 3: Opcion que se va a mostrar por defecto
	 */
	def CharSequence radioChooser(ViewInstance part) '''
		<div class="form-group">
			<div class="col-md-10">
				@foreach (var x in «generateVariableReference(part.parameters.get(1).cast(VariableReference))»  as )
				{
					@Html.RadioButtonFor(model => «generateVariableReference(part.parameters.get(2).cast(VariableReference))», x.id«IF part.parameters.get(3) instanceof StringValue», x.«part.parameters.get(0).writeExpression» == "«part.parameters.get(3).writeExpression»" ? new { @checked = "checked" } : null«ENDIF») @x.«part.parameters.get(0).writeExpression»
					<br />
				}
			</div>
		</div>
	'''
		
	/**
	 * Método encargado de generar elementos de tipo imágen
	 * 
	 */
	def CharSequence image(ViewInstance part)'''
		<img height="120" src="«IF part.parameters.get(0) instanceof VariableReference»@«generateVariableReference(part.parameters.get(0).cast(VariableReference))»«ELSE»«part.parameters.get(0).getValue»«ENDIF»">
	'''
	
	/**
	 * Método encargado de generar elementos de tipo multimedia, como videos o animaciones
	 * 
	 */
	def CharSequence Media(ViewInstance part) '''
	    <iframe width="«part.parameters.get(1).getValue»" height="«part.parameters.get(2).getValue»"  src="«IF part.parameters.get(0) instanceof VariableReference»@«generateVariableReference(part.parameters.get(0).cast(VariableReference))»«ELSE»«part.parameters.get(0).getValue»«ENDIF»" frameborder="0" allowfullscreen></iframe>
	'''

	/**
	 * Método encargado de generar elementos de tipo link
	 * 
	 */
	def CharSequence link(ViewInstance part)'''
		<a href="«IF part.parameters.get(1) instanceof VariableReference»@«generateVariableReference(part.parameters.get(1).cast(VariableReference))»«ELSE»«part.parameters.get(1).getValue»«ENDIF»">«IF part.parameters.get(0) instanceof VariableReference»@«generateVariableReference(part.parameters.get(0).cast(VariableReference))»«ELSE»«part.parameters.get(0).getValue»«ENDIF»</a>
	'''
	
	/**
	 * Método encargado de generar elementos de tipo label que son alimentados desde un modelo
	 * 
	 */
	def CharSequence label(ViewInstance part) '''
	«IF part.parameters.get(0) instanceof VariableReference»
		@Html.DisplayFor(model => «generateVariableReference(part.parameters.get(0).cast(VariableReference))»)
	«ELSE»
		«IF isTagHTMLValid(part.parameters.get(0).getValue.toString())»
			«part.parameters.get(0).getValue»
		«ELSE»			
			<label class="control-label col-md-2">«part.parameters.get(0).getValue»</label>			
		«ENDIF»
		«ENDIF»'''
	
	def boolean isTagHTMLValid(String html){
		if( html.contains("</div>") || html.contains("</p>"))
		{
			return true
		}else
		{
			return false;			
		}				
	}
	
	
	def CharSequence generateVariableReference(VariableReference vr) '''
	«IF vr.referencedElement.name==modelname»Model«generateTailedElementOmitFirst(vr)»«ELSEIF listViewBag.contains(vr.referencedElement.name)»ViewBag.«generateTailedElement(vr)»«ELSE»«generateTailedElement(vr)»«ENDIF»'''
	

	
	def CharSequence getValue(Expression e){
		switch e{
			BoolValue		: e.literal.toString
			FloatValue		: e.literal.toString
			IntValue		: e.literal.toString
			NullValue		: "null"
			StringValue		: e.literal.toString
			MethodCall		: "call"
			VariableReference: if (hasTail(e)) generateLastTailedElement(e) else e.referencedElement.name
			default: e.toString
		}
	}
	
	
	/**
	 * Método encargado de generar elementos de tipo botón
	 * 
	 */
	def CharSequence button(ViewInstance part) '''
	    «IF part.actionCall.action.name.toUpperCase()==pagename.toUpperCase()»
	    <div class="form-group">
	    	<div class="col-md-offset-2 col-md-10">
	    		<input type="submit" value="«part.parameters.get(0).writeExpression»"  class="btn btn-default" />
	    	</div>
	    </div>
	    «ELSE»@Html.ActionLink("«part.parameters.get(0).writeExpression»", "«part.actionCall.action.name.toFirstUpper»"«generateParametersActionCall(part.actionCall)»)«ENDIF»
	'''	
	
	
	/**
	 * This method generates the parameters for a given ActionCall, using the Blade format.
	 * @param call an action call
	 * @return formatted parameters
	 * 
	*/
	def CharSequence generateParametersActionCall(ActionCall call) 
	'''«IF call.parameters.size>0», new { «FOR i: 0..<call.action.parameters.size SEPARATOR ','»«call.action.parameters.get(i).name» = «valueTemplateForEntities(call.parameters.get(i))»«ENDFOR» }«ENDIF»'''	
	
	
	/**
	 * Enhanced version of the valueTemplate method with a somewhat<br>
	 * different format if the Expression is an ReferencedElement Entity.
	 * @return the current date
	 * */
	def CharSequence valueTemplateForEntities(Expression e){
		if(e instanceof VariableReference){
			if(e.referencedElement.type.typeSpecification instanceof Entity){
				return '''«generateVariableReference(e)»'''
			}else{
				return ''''''
			}
		}
		else if(e instanceof StructInstance){
			return ''''''
		}		
		return valueTemplate(e)
	}
		
	/**
	 * Método encargado de generar un panel de botones
	 * 
	 */
	def CharSequence panelButton(ViewInstance viewInstance) '''
		<p>
        	«FOR partBlock : viewInstance.body»
				«widgetTemplate(partBlock)» 
			«ENDFOR»
		</p>
	'''	
	
	def CharSequence scriptsTemplate() 
	'''
		«IF listCalendar.size>0»
		@section Scripts{
		    @Scripts.Render("~/bundles/jqueryval")
		}		
		
		<script type="text/javascript">
		«FOR item : listCalendar»
		    $(function () {
		        $('#«item»').datetimepicker({
		            format: "DD/MM/YYYY",
		            showTodayButton: true,
		            defaultDate: new Date()
		        }).on('dp.change', function (e) {
		            $(this).data('DateTimePicker').hide();
		        });
		    });
		    
		«ENDFOR»		
		</script>
		«ENDIF»	
	'''	
	
	/**
	 * Metodo para generar elementos graficos de tipo data table
	 * 
	 */
	
	def CharSequence dataTable(ViewInstance table) '''
	<table class="table">
		<tr>
  		«FOR pair : table.getColumnsDataTable.entrySet»
  			«val viewInstance = pair.key as ViewInstance»
  			<th>
  				«widgetTemplate(viewInstance)»
  			</th>
   		«ENDFOR»
		</tr>
	@foreach («IF table.forViewInBody.variable.type.typeSpecification instanceof Entity»AplicacionWeb.«table.forViewInBody.variable.type.typeSpecification.fullyQualifiedName»«ELSE»var«ENDIF» «table.forViewInBody.variable.name» in «IF table.forViewInBody.collection.referencedElement.name==modelname»Model«generateTailedElementOmitFirst(table.forViewInBody.collection)»«ELSEIF listViewBag.contains(table.forViewInBody.collection.referencedElement.name)»ViewBag.«generateTailedElement(table.forViewInBody.collection)»«ELSE»«generateTailedElement(table.forViewInBody.collection)»«ENDIF») {
		<tr>
  			«val forView = table.body.get(1).cast(NamedViewBlock).body.get(0) as ForView»
  			«val tiposColumnas = new ArrayList<String>»
  		«FOR i : 0 ..< forView.body.size»
  			«var elemento = forView.body.get(i)»
  			«var tipo = elemento.type.referencedElement.name»
  			«{ tiposColumnas.add(tipo); "" }»
  		«ENDFOR»
		«var i = 0»
  		«FOR pair : table.getColumnsDataTable.entrySet»
  			«val tipoColumna = tiposColumnas.get(i)»
  			«IF "Button".equals(tipoColumna)»
  			<td>
  				«widgetTemplate(pair.value)»
  			</td>
	 		«ELSE»
  			<td>
  				«widgetTemplate(pair.value)»
  			</td>
 			«ENDIF»
 			«{ i = i + 1; "" }»
   		«ENDFOR»
		</tr>
	}
	</table>
	'''
	
	/**
	 * Método para obtener las columnas de un datatable
	 * 
	 */
	def getColumnsDataTable(ViewInstance table) {
		val columns = new LinkedHashMap<ViewStatement, ViewStatement>
		val header = table.body.get(0) as NamedViewBlock
		val forView = table.body.get(1).cast(NamedViewBlock).body.get(0) as ForView
		for (i : 0 ..< header.body.size) {
			columns.put(header.body.get(i), forView.body.get(i))
			
		}
		return columns
	}	
	
	/**
	 * Método para obtener el id de un componente
	 * 
	 */
	def getId(ViewInstance part){
		if(part.name!= null){
			return part.name
		}else{
			return part.view.name.toFirstLower + i++;
		}		
	}
	
	
	/**
	 * Método para asignar las columnas de un componente
	 * 
	 */
	def getThisId(ViewInstance part){
			j = 0;
		if(part.name!= null){
			return part.name
		}else{
			j =i;
			return part.view.name.toFirstLower+j;
		}		
	}
	
	
	/**
	 * Método para obtener las partes de cada componente de tipo block
	 * 
	 */
	def dispatch CharSequence widgetTemplate(EList<ViewStatement> partBlock)'''
		«IF partBlock != null»
			«FOR part : partBlock»	
				«widgetTemplate(part)»				
			«ENDFOR»
		«ENDIF»
			
	'''	
	
	/**
	 * Método para asignar valores a los componentes 
	 * 
	 */
	def CharSequence valueTemplate(Expression expression){		
		if(expression instanceof Reference){
			if (expression instanceof ResourceReference){
				return expression.writeExpression
			}else if(expression instanceof VariableReference){
				return expression.writeReference
			}
		} else{
			return expression.writeExpression
		}
	}	

}

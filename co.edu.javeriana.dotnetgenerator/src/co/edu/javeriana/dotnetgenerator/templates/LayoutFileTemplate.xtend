package co.edu.javeriana.dotnetgenerator.templates


import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Action
import java.util.List
import co.edu.javeriana.isml.isml.CompositeTypeSpecification
import co.edu.javeriana.isml.isml.Controller
import co.edu.javeriana.isml.scoping.IsmlModelNavigation
import com.google.inject.Inject

class LayoutFileTemplate extends SimpleTemplate<List<CompositeTypeSpecification>> {
	
	@Inject extension IsmlModelNavigation

	/**
	 * This method fills the List&ltTypedElement> imports (where are the typed elements to<br>
	 * go in the routes) and the Set&ltEntity> entitySubGroup (where are the referenced entities<br>
	 * in the routes).
	 * @param lc Controller list to make the Routes archive
	 * */
	override preprocess(List<CompositeTypeSpecification> list){
	}
	
	/**
	 * This method makes the C# project File with a list of ISML controllers, pages, models.
	 * @param e the controller list
	 * @return the C# Routes archive
	 * */
	override protected  template(List<CompositeTypeSpecification> e) '''
		<!DOCTYPE html>
		<html>
		<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
		    <meta charset="utf-8" />
		    <meta name="viewport" content="width=device-width, initial-scale=1.0">
		    <title>@ViewBag.Title - PetStore</title>
		    @Styles.Render("~/Content/css")
		    @Scripts.Render("~/bundles/modernizr")
		    @Scripts.Render("~/bundles/jquery")
		</head>
		<body>
		    <div class="navbar navbar-inverse navbar-fixed-top">
		        <div class="container">
		            <div class="navbar-header">
		                <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
		                    <span class="icon-bar"></span>
		                    <span class="icon-bar"></span>
		                    <span class="icon-bar"></span>
		                </button>
		                @Html.ActionLink("Pet-Store", "Index", "Home", new { area = "" }, new { @class = "navbar-brand" })
		            </div>
		            <div class="navbar-collapse collapse">
		                <ul class="nav navbar-nav">
		                    <li>@Html.ActionLink("Inicio", "Index", "Home")</li>
							«FOR item: e»
							«IF item instanceof Controller && !item.name.equals("DefaultPageDispatcher") && !item.name.equals("AnyController")»
							«IF item.name!="HomeController" && getActionDefault(item as Controller).toString.isNullOrEmpty==false»<li>@Html.ActionLink("«item.name.replace("Controller","").replace("_"," de ")»", "«getActionDefault(item as Controller)»", "«item.name.replace("Controller","")»")</li>«ENDIF»
							«ENDIF»
							«ENDFOR»		                    
		                </ul>
		            </div>
		        </div>
		    </div>
		    <div class="container body-content">
		        @RenderBody()
		        <hr />
		        <footer>
		            <p>&copy; @DateTime.Now.Year - Proyecto DotNetGenerator - Maestr&#237;a en Ingenier&#237;a de Sistemas y Computaci&#243;n, Pontificia Universidad Javeriana</p>
		        </footer>
		    </div>
		
		
		    @Scripts.Render("~/bundles/bootstrap")
		    @RenderSection("scripts", required: false)
		</body>
		</html>'''
	
	def getActionDefault(Controller c)
	{		
		for (act: c.actions)
		{
			if(act.isDefault)
			{
				return act.name
			}else
			{
				return ""
			}						
		}
	}	
	
	/**
	 * This method formats a parameter list from an Action for put them in the action's relative URL.
	 * @param action a Controller Action
	 * @return formatted string for the parameters
	 * */
	def CharSequence generateParameters(Action action) {
		var CharSequence cs= ''''''
		if(action.parameters.size>0){
			cs='''«FOR param: action.parameters»/{«param.name»}«ENDFOR»'''
		}
		else
			return cs
	}
	
}
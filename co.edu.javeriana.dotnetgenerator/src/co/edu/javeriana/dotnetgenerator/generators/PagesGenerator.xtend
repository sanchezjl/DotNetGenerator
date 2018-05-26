package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.isml.isml.Page
import org.eclipse.xtext.naming.IQualifiedNameProvider
import com.google.inject.Inject
import co.edu.javeriana.dotnetgenerator.templates.PagesTemplate

class PagesGenerator extends SimpleGenerator<Page> {
	
	@Inject extension IQualifiedNameProvider
	
	override getOutputConfigurationName() {
		DotNetGenerator.VIEWS
	}
	
	override protected getFileName(Page e) {
		return e.eContainer?.fullyQualifiedName.toString("/").toFirstUpper + "/" + e.name + ".cshtml"
	}
	
	override getTemplate() {
		return new PagesTemplate
	}
	
}
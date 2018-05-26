package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import java.util.List
import co.edu.javeriana.dotnetgenerator.templates.ProjectFileTemplate
import co.edu.javeriana.isml.isml.CompositeTypeSpecification

class ProyectFileGenerator extends SimpleGenerator<List<CompositeTypeSpecification>> {
	
	override protected getFileName(List<CompositeTypeSpecification> e) {
		return "AplicacionWeb.csproj";
	}
	
	override protected getOutputConfigurationName() {
		DotNetGenerator.PROJECTFILE
	}
	
	override getTemplate() {
		return new ProjectFileTemplate
	}
	
}
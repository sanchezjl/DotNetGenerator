package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import java.util.List
import co.edu.javeriana.isml.isml.CompositeTypeSpecification
import co.edu.javeriana.dotnetgenerator.templates.ProjectFileTemplateModels

class ProyectFileGeneratorModels extends SimpleGenerator<List<CompositeTypeSpecification>> {
	
	override protected getFileName(List<CompositeTypeSpecification> e) {
		return "AplicacionWeb.Models.csproj";
	}
	
	override protected getOutputConfigurationName() {
		DotNetGenerator.PROJECTFILEMODELS
	}
	
	override getTemplate() {
		return new ProjectFileTemplateModels
	}
	
}
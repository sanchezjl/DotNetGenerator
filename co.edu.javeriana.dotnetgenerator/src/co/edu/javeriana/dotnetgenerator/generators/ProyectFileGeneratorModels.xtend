package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import java.util.List
import co.edu.javeriana.isml.isml.CompositeTypeSpecification
import co.edu.javeriana.dotnetgenerator.templates.ProjectFileTemplateServices

class ProyectFileGeneratorServices extends SimpleGenerator<List<CompositeTypeSpecification>> {
	
	override protected getFileName(List<CompositeTypeSpecification> e) {
		return "AplicacionWeb.Services.csproj";
	}
	
	override protected getOutputConfigurationName() {
		DotNetGenerator.PROJECTFILESERVICES
	}
	
	override getTemplate() {
		return new ProjectFileTemplateServices
	}
	
}
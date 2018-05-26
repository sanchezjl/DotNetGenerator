package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import java.util.List
import co.edu.javeriana.isml.isml.CompositeTypeSpecification
import co.edu.javeriana.dotnetgenerator.templates.ProjectFileTemplateDAL

class ProyectFileGeneratorDAL extends SimpleGenerator<List<CompositeTypeSpecification>> {
	
	override protected getFileName(List<CompositeTypeSpecification> e) {
		return "AplicacionWeb.DAL.csproj";
	}
	
	override protected getOutputConfigurationName() {
		DotNetGenerator.PROJECTFILEDAL
	}
	
	override getTemplate() {
		return new ProjectFileTemplateDAL
	}
	
}
package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import java.util.List
import co.edu.javeriana.isml.isml.CompositeTypeSpecification
import co.edu.javeriana.dotnetgenerator.templates.LayoutFileTemplate

class LayoutFileGenerator extends SimpleGenerator<List<CompositeTypeSpecification>> {
	
	override protected getFileName(List<CompositeTypeSpecification> e) {
		return "_Layout.cshtml";
	}
	
	override protected getOutputConfigurationName() {
		DotNetGenerator.LAYOUTFILE
	}
	
	override getTemplate() {
		return new LayoutFileTemplate
	}
	
}
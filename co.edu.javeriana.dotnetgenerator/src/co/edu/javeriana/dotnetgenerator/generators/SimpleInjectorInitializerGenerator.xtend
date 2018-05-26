package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.isml.isml.Entity
import java.util.List
import co.edu.javeriana.dotnetgenerator.templates.SimpleInjectorInitializerTemplate
import co.edu.javeriana.isml.isml.CompositeTypeSpecification

class SimpleInjectorInitializerGenerator extends SimpleGenerator<List<CompositeTypeSpecification>> {

	override protected getFileName(List<CompositeTypeSpecification> e) {
		return "SimpleInjectorInitializer.cs"		
	}

	override protected getOutputConfigurationName() {
		DotNetGenerator.SIMPLEINJECTORINITIALIZERFILE
	}
	
	override getTemplate() {
		return new SimpleInjectorInitializerTemplate
	}

}
package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.isml.isml.Controller
import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.dotnetgenerator.templates.ControllerTemplate
import co.edu.javeriana.dotnetgenerator.DotNetGenerator

class ControllerGenerator extends SimpleGenerator<Controller> {
	
	override protected getFileName(Controller e) {
		return e.name + ".cs";
	}
	
	override protected getOutputConfigurationName() {
		DotNetGenerator.CONTROLLERS
	}
	
	override getTemplate() {
		return new ControllerTemplate
	}
	
}
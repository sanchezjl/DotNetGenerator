package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.isml.isml.Service
import co.edu.javeriana.dotnetgenerator.templates.ServiceImplementationTemplate

class ServiceImplementationGenerator extends SimpleGenerator<Service> {

	override getFileName(Service e) {
		return e.name + ".cs"
	}

	override getOutputConfigurationName() {
		DotNetGenerator.SERVICE_IMPLEMENTATION
	}
	
	override getTemplate() {
		return new ServiceImplementationTemplate
	}

}
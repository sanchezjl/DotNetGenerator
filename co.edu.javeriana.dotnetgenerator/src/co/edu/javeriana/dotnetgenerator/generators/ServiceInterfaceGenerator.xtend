package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import co.edu.javeriana.dotnetgenerator.templates.ServiceInterfaceTemplate
import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.isml.isml.Service


class ServiceInterfaceGenerator extends SimpleGenerator<Service> {

	override getFileName(Service e) {
		return "I"+e.name + ".cs"
	}

	override getOutputConfigurationName() {
		DotNetGenerator.SERVICE_INTERFACE
	}
	
	override getTemplate() {
		return new ServiceInterfaceTemplate
	}

}

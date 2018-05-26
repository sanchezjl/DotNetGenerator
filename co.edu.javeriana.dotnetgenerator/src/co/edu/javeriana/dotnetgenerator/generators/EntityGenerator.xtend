package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import co.edu.javeriana.dotnetgenerator.templates.EntityTemplate
import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.isml.isml.Entity

class EntityGenerator extends SimpleGenerator<Entity> {

	override getFileName(Entity e) {
		return e.name + ".cs"
		
	}

	override getOutputConfigurationName() {
		DotNetGenerator.ENTITIES
	}
	
	override getTemplate() {
		return new EntityTemplate

	}

}
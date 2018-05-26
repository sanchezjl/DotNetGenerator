package co.edu.javeriana.dotnetgenerator.generators

import co.edu.javeriana.dotnetgenerator.DotNetGenerator
import co.edu.javeriana.isml.generator.common.SimpleGenerator
import co.edu.javeriana.isml.isml.Entity
import co.edu.javeriana.dotnetgenerator.templates.ApplicationDbContextTemplate
import java.util.List

class ApplicationDbContextGenerator extends SimpleGenerator<List<Entity>> {

	override protected getFileName(List<Entity> e) {
		return "ApplicationDbContext.cs"		
	}

	override protected getOutputConfigurationName() {
		DotNetGenerator.APPLICATIONDBCONTEXTFILE
	}
	
	override getTemplate() {
		return new ApplicationDbContextTemplate
	}

}
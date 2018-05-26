package co.edu.javeriana.dotnetgenerator

import co.edu.javeriana.isml.generator.common.GeneratorSuite
import co.edu.javeriana.isml.generator.common.OutputConfiguration
import co.edu.javeriana.dotnetgenerator.generators.EntityGenerator
import co.edu.javeriana.dotnetgenerator.generators.PagesGenerator
import co.edu.javeriana.dotnetgenerator.generators.ControllerGenerator
import co.edu.javeriana.dotnetgenerator.generators.ProyectFileGenerator
import co.edu.javeriana.dotnetgenerator.generators.LayoutFileGenerator
import co.edu.javeriana.dotnetgenerator.generators.ApplicationDbContextGenerator
import co.edu.javeriana.dotnetgenerator.generators.SimpleInjectorInitializerGenerator
import co.edu.javeriana.dotnetgenerator.generators.ServiceInterfaceGenerator
import co.edu.javeriana.dotnetgenerator.generators.ServiceImplementationGenerator
import co.edu.javeriana.dotnetgenerator.generators.ProyectFileGeneratorDAL
import co.edu.javeriana.dotnetgenerator.generators.ProyectFileGeneratorModels
import co.edu.javeriana.dotnetgenerator.generators.ProyectFileGeneratorServices

class DotNetGenerator extends GeneratorSuite {
	
	@OutputConfiguration
	public static final String ENTITIES = "entities";
	
	@OutputConfiguration
	public static final String CONTROLLERS = "controllers"
	
	@OutputConfiguration
	public static final String VIEWS = "views";
	
	@OutputConfiguration
	public static final String PROJECTFILE = "projectfile";
	
	@OutputConfiguration
	public static final String PROJECTFILEDAL = "projectfile.dal";
	
	@OutputConfiguration
	public static final String PROJECTFILEMODELS = "projectfile.models";
	
	@OutputConfiguration
	public static final String PROJECTFILESERVICES = "projectfile.services";
	
	@OutputConfiguration
	public static final String LAYOUTFILE = "layoutfile";
	
	@OutputConfiguration
	public static final String APPLICATIONDBCONTEXTFILE = "applicationdbcontextfile";
	
	@OutputConfiguration
	public static final String SIMPLEINJECTORINITIALIZERFILE = "simpleinjectorinitializerfile";
	
	@OutputConfiguration
	public static final String SERVICE_IMPLEMENTATION = "service.implementation"
	
	@OutputConfiguration
	public static final String SERVICE_INTERFACE = "service.interface"
	
	override getGenerators() {
		#{
			new EntityGenerator,
			new PagesGenerator,
			new ControllerGenerator,
			new ProyectFileGenerator,
			new ProyectFileGeneratorDAL,
			new ProyectFileGeneratorModels,
			new ProyectFileGeneratorServices,
			new LayoutFileGenerator,
			new ApplicationDbContextGenerator,
			new SimpleInjectorInitializerGenerator,
			new ServiceInterfaceGenerator,
			new ServiceImplementationGenerator	
		}
	}			

}

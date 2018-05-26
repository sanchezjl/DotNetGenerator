package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Entity
import java.util.List
import co.edu.javeriana.isml.isml.CompositeTypeSpecification
import co.edu.javeriana.isml.isml.Service

public class SimpleInjectorInitializerTemplate extends SimpleTemplate<List<CompositeTypeSpecification>> {

	/*Metodo callback llamado previo a la ejecución del template*/
	override preprocess(List<CompositeTypeSpecification> list) {
	
	}

/*	Plantilla para generar el archivo ApplicationDbContext.cs*/
	override def CharSequence template(List<CompositeTypeSpecification> e) '''
		[assembly: WebActivator.PostApplicationStartMethod(typeof(AplicacionWeb.App_Start.SimpleInjectorInitializer), "Initialize")]
		
		namespace AplicacionWeb.App_Start
		{
		    using System.Reflection;
		    using System.Web.Mvc;
		
		    using SimpleInjector;
		    using SimpleInjector.Integration.Web;
		    using SimpleInjector.Integration.Web.Mvc;
		    using AplicacionWeb.Models;
		    using AplicacionWeb.DAL;
		    using AplicacionWeb.Services;
		
		    public static class SimpleInjectorInitializer
		    {
		        /// <summary>Initialize the container and register it as MVC3 Dependency Resolver.</summary>
		        public static void Initialize()
		        {
		            var container = new Container();
		            container.Options.DefaultScopedLifestyle = new WebRequestLifestyle();
		            
		            InitializeContainer(container);
		
		            container.RegisterMvcControllers(Assembly.GetExecutingAssembly());
		            
		            container.Verify();
		            
		            DependencyResolver.SetResolver(new SimpleInjectorDependencyResolver(container));
		        }
		     
		        private static void InitializeContainer(Container container)
		        {
		            // For instance:
		            // container.Register<IUserRepository, SqlUserRepository>(Lifestyle.Scoped);
		            
				    «FOR itemEntity: e»
				    	«IF itemEntity instanceof Entity »
				    		container.Register<IPersistence<«itemEntity.name»>, Persistence<«itemEntity.name»>>(Lifestyle.Scoped);
				    	«ENDIF»
				    «ENDFOR»
				    
					«FOR item: e»
					«IF item instanceof Service && !item.name.equals("Persistence") && !item.name.equals("Convert") && !item.name.equals("Query")»
					«IF !item.genericTypeParameters.isEmpty»				
					«FOR itemEntity: e»
					«IF itemEntity instanceof Entity »					
					container.Register<I«item.name»<«itemEntity.name»>, «item.name»<«itemEntity.name»>>(Lifestyle.Scoped);
					«ENDIF»
					«ENDFOR»
					«ELSE»
					container.Register<I«item.name», «item.name»>(Lifestyle.Scoped);
					«ENDIF»
					
					«ENDIF»				    	
					«ENDFOR»
		        }
		    }
		}'''
}

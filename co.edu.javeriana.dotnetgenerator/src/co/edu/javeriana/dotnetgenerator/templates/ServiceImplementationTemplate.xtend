package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Attribute
import co.edu.javeriana.isml.isml.Method
import co.edu.javeriana.isml.isml.ParameterizedType
import co.edu.javeriana.isml.isml.Service
import co.edu.javeriana.isml.scoping.IsmlModelNavigation
import com.google.inject.Inject
import co.edu.javeriana.dotnetgenerator.utils.UtilGenerator


class ServiceImplementationTemplate extends SimpleTemplate<Service> {

	@Inject extension IsmlModelNavigation
	@Inject extension UtilGenerator	
	
	override def CharSequence template(Service service) '''
		using System;
		using System.Collections.Generic;

		namespace AplicacionWeb.Services
		{
		    /// <summary>
		    /// This interface represents the local instance for the «service.name»
		    /// </summary>
			public class «service.name»«IF !service.genericTypeParameters.isEmpty»<«FOR param:service.genericTypeParameters SEPARATOR ','»«param.name»«ENDFOR»>«ENDIF» «IF !service.superTypes.empty»extends «service.superTypes.get(0).typeSpecification.name»«IF service.superTypes.get(0).typeSpecification instanceof Service»«IF service.superTypes.get(0)instanceof ParameterizedType»<«FOR param: (service.superTypes.get(0)as ParameterizedType).typeParameters SEPARATOR ','»«param.writeType(true)»«ENDFOR»>«ENDIF»«ENDIF»«ENDIF» : I«service.name»«IF !service.genericTypeParameters.isEmpty»<«FOR param:service.genericTypeParameters SEPARATOR ','»«param.name»«ENDFOR»>«ENDIF»
			{
				«FOR feature : service.features»
					«IF feature instanceof Method»
						/// <summary>
						/// This method executes the proper actions for «feature.name»
						/// </summary>
						«FOR param:feature.parameters»
						/// <param name="«param.name»"></param>
						«ENDFOR»
						public «getDataType(feature.type)» «feature.name.toFirstUpper»(«FOR parameter : feature.parameters SEPARATOR ','»«IF feature.type.typeSpecification.name.equalsIgnoreCase("void") && feature.parameters.size!=1»string «parameter.name»«ELSE»«getDataType(parameter.type)» «parameter.name»«ENDIF»«ENDFOR»)
						{
							// Implementation code goes here.
							throw new NotImplementedException();
						}
						
					«ELSE»
						«IF feature instanceof Attribute»
							public «getDataType(feature.type)» «feature.name»  { get; set; }
						«ENDIF»
					«ENDIF»				
				«ENDFOR»
			}
		}
	'''
	


}
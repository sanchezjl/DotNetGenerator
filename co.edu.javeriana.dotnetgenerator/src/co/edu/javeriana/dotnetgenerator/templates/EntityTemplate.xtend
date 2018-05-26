package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.isml.Instance
import co.edu.javeriana.isml.isml.LiteralValue
import co.edu.javeriana.isml.isml.Parameter
import co.edu.javeriana.isml.isml.ParameterizedType

import co.edu.javeriana.isml.validation.TypeChecker
import com.google.inject.Inject
import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Attribute
import co.edu.javeriana.isml.isml.Constraint
import co.edu.javeriana.isml.isml.Entity
import co.edu.javeriana.isml.isml.Primitive
import co.edu.javeriana.isml.scoping.IsmlModelNavigation
import org.eclipse.xtext.naming.IQualifiedNameProvider
import co.edu.javeriana.dotnetgenerator.utils.UtilGenerator
import co.edu.javeriana.isml.isml.ConstraintInstance

public class EntityTemplate extends SimpleTemplate<Entity> {
	@Inject extension TypeChecker
	/*Inyección de las clases auxiliares con metodos utilitarios*/
	@Inject extension IQualifiedNameProvider
	@Inject extension IsmlModelNavigation
	@Inject extension UtilGenerator	
	
	/*Metodo callback llamado previo a la ejecución del template*/
	override preprocess(Entity e) {
	
	}

	/*Plantilla para generar entidades*/
	override def CharSequence template(Entity entity) '''
		using System;
		using System.Collections.Generic;
		using System.ComponentModel.DataAnnotations;
		using System.ComponentModel.DataAnnotations.Schema;
		
		namespace AplicacionWeb.«entity.eContainer.fullyQualifiedName»
		{«/*Declaracion de la entidad*/ »
			public class «entity.name.toFirstUpper» : Entity
			{«/*Se recorren los atributos de la entidad para verificar si son de tipo email, lista o tipos primitivos  */ »
				«FOR Attribute attributes : entity.attributes»					
					«FOR constraint : attributes.constraints»«/*Se agregan las anotaciones segun los constraint definidos*/ »
						«generateConstraint(constraint)»
					«ENDFOR»
					«IF attributes.name.toUpperCase() != "ID"»
						«IF attributes.type.typeSpecification.typeSpecificationString.equalsIgnoreCase("email")»
							public string «attributes.name.toFirstUpper» { get; set; }
						«ELSE»
							«IF attributes.type.isCollection»
							public virtual «getCollectionString(attributes.type as ParameterizedType)»<«(attributes.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»> «attributes.name.toFirstUpper» { get; set; }
							«ELSE»
							public «IF attributes.type.typeSpecification instanceof Entity»virtual «ENDIF»«generateType(attributes.type.typeSpecification.name)» «attributes.name.toFirstUpper» { get; set; }
							«ENDIF»
						«ENDIF»
					«ENDIF»
					
				«ENDFOR»
			}
		}
	'''
	
	/*Metodo que permite generar un constraint para una clase modelo en C#*/
	def CharSequence generateConstraint(ConstraintInstance constraint) '''
		«IF constraint.type.typeSpecification.typeSpecificationString== "NotNull"»
			[Required]
		«ELSEIF constraint.type.typeSpecification.typeSpecificationString== "NotEmpty"»
			[MinLength(1)]
		«ELSEIF constraint.type.typeSpecification.typeSpecificationString== "Size"»
			[Range(«constraint.parametersTemplate»)]
		«ELSEIF constraint.type.typeSpecification.typeSpecificationString== "Max"»
			[MaxLength(«constraint.parametersTemplate»)]
		«ELSEIF constraint.type.typeSpecification.typeSpecificationString== "Min"»
			[MinLength(«constraint.parametersTemplate»)]
		«ENDIF»
		'''	
	
	def boolean evaluateAttributeToImport(Attribute attribute, Entity entity){
		var boolean needImport=false;
		if(!attribute.type.isCollection){
			needImport=!attribute.type.typeSpecification.eContainer.fullyQualifiedName.equals(entity.eContainer.fullyQualifiedName)
		} else {
			needImport=!(attribute.type as ParameterizedType).typeParameters.get(0).typeSpecification.eContainer.fullyQualifiedName.equals(entity.eContainer.fullyQualifiedName)
		}
		return needImport
	}
	
	def boolean isDatePresent(Entity entity){
		var boolean hasDate=false
		for(attr:entity.attributes){
			if(attr.type.typeSpecification instanceof Primitive && attr.type.typeSpecification.typeSpecificationString.equalsIgnoreCase("Date")){
				hasDate=true
			}
		}
		return hasDate
	}
	def CharSequence getParametersTemplate(Instance constraint) '''
		«IF !constraint.parameters.empty»«FOR Parameter parameter : setParametersValue((constraint.type.typeSpecification as Constraint).parameters, constraint.parameters) SEPARATOR ","»«IF parameter.type.typeSpecification.typeSpecificationString.equalsIgnoreCase("string")»"«(parameter.value as LiteralValue).literal»"«ELSE»«(parameter.value as LiteralValue).literal»«ENDIF»«ENDFOR»«ENDIF»'''
 
	
	
}

package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Entity
import java.util.List
import co.edu.javeriana.isml.isml.ParameterizedType

import co.edu.javeriana.isml.validation.TypeChecker
import com.google.inject.Inject
import co.edu.javeriana.isml.isml.Attribute
import co.edu.javeriana.isml.scoping.IsmlModelNavigation
import co.edu.javeriana.dotnetgenerator.utils.UtilGenerator

public class ApplicationDbContextTemplate extends SimpleTemplate<List<Entity>> {

	/*Inyección de las clases auxiliares con metodos utilitarios*/	
	@Inject extension TypeChecker
	@Inject extension IsmlModelNavigation
	@Inject extension UtilGenerator	
	
	/*Metodo callback llamado previo a la ejecución del template*/
	override preprocess(List<Entity> e) {
	
	}

/*	Plantilla para generar el archivo ApplicationDbContext.cs*/
	override def CharSequence template(List<Entity> entity) '''
		using System;
		using System.Collections.Generic;
		using System.Data.Entity;
		using System.Data.Entity.ModelConfiguration.Conventions;
		using System.Linq;
		using System.Web;
		using AplicacionWeb.Models;
		
		namespace AplicacionWeb.DAL
		{«/*Declaracion de la entidad*/ »
			public class ApplicationDbContext : DbContext
			{
				«FOR Entity attributes : entity»
				public DbSet<«attributes.name»> «attributes.name» { get; set; }
				«ENDFOR»
				
				protected override void OnModelCreating(DbModelBuilder modelBuilder)
				{
					modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
					«FOR Entity item : entity»
					modelBuilder.Entity<«item.name»>().ToTable("«item.name»");
					«ENDFOR»
					
					//Fluent API relationships
					«FOR Entity item : entity»
						«FOR Attribute attributes : item.attributes»
							«generateRelationships(attributes,item.name)»
						«ENDFOR»
					«ENDFOR»					
					
				}
			}
		}
	'''
	
	def CharSequence generateRelationships(Attribute a, String entityname) {
		if (a.evaluateCardinality) {
			if (a.type.isCollection) {
				if (a.opposite != null) {

					/*Se verifica el mapeo de la entidad
					 * para indicar atributo maestro
					 */
					if (a.opposite.type.isCollection) {
						return '''
						//ManyToMany mappedBy "«a.opposite.name.toFirstUpper»"
						modelBuilder.Entity<«entityname»>()
						.HasMany<«(a.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»>(p => p.«a.name.toFirstUpper»)
						.WithRequired(p => p.«a.opposite.name.toFirstUpper»)
						.HasForeignKey<int>(p => p.«a.opposite.name.toFirstUpper»id)
						.WillCascadeOnDelete(false);
						
						'''
					} else {
						return '''
						//OneToMany mappedBy "«a.opposite.name.toFirstUpper»"
						modelBuilder.Entity<«entityname»>()
						.HasMany<«(a.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»>(p => p.«a.name.toFirstUpper»)
						.WithRequired(p => p.«a.opposite.name.toFirstUpper»)
						.HasForeignKey<int>(p => p.«a.opposite.name.toFirstUpper»id)
						.WillCascadeOnDelete(false);
						
						'''
					}
				} else {
					val opposite = a.searchOpposite

					if (opposite != null)
						if (opposite.type.isCollection) {
							return '''
							//ManyToMany
							modelBuilder.Entity<«entityname»>()
							.HasRequired <«generateType(a.type.typeSpecification.name)»> (p => p.«a.name.toFirstUpper»);
							
							'''
						} else {
							return '''
							//OneToMany mappedBy "«a.searchOpposite.name.toFirstUpper»"
							modelBuilder.Entity<«entityname»>()
							.HasMany<«(a.type as ParameterizedType).typeParameters.get(0).typeSpecification.typeSpecificationString»>(p => p.«a.name.toFirstUpper»)
							.WithRequired(p => p.«a.searchOpposite.name.toFirstUpper»)
							.HasForeignKey<int>(p => p.«a.searchOpposite.name.toFirstUpper»id)
							.WillCascadeOnDelete(false);
							
							'''
						}
				}
			} else {
				if (a.opposite != null) {
					if (a.opposite.type.isCollection) {
						return '''
						//ManyToOne
						modelBuilder.Entity<«entityname»>()
						.HasRequired<«generateType(a.type.typeSpecification.name)»>(p => p.«a.name.toFirstUpper»);
						
						'''
					} else {
						return '''
						//OneToOne mappedBy "«a.opposite.name.toFirstUpper»"
						modelBuilder.Entity<«entityname»>()
						.HasOptional(p => p.«a.name.toFirstUpper»)
						.WithRequired(p => p.«a.opposite.name.toFirstUpper»);
						
						'''
					}
				} else {
					if (a.searchOpposite.type.isCollection) {
						return '''
						//ManyToOne
						modelBuilder.Entity<«entityname»>()
						.HasRequired<«generateType(a.type.typeSpecification.name)»>(p => p.«a.name.toFirstUpper»); 
						
						'''
					} else {
						return '''
						//OneToOne
						modelBuilder.Entity<«entityname»>()
						.HasRequired<«generateType(a.type.typeSpecification.name)»>(p => p.«a.name.toFirstUpper»);
						
						'''
					}
				}
			}
		}

	}
	
}

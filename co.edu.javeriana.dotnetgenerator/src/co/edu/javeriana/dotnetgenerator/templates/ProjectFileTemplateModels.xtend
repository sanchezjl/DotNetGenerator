package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Action
import co.edu.javeriana.isml.isml.Entity
import com.google.inject.Inject
import java.util.List
import org.eclipse.xtext.naming.IQualifiedNameProvider
import co.edu.javeriana.isml.isml.CompositeTypeSpecification

class ProjectFileTemplateModels extends SimpleTemplate<List<CompositeTypeSpecification>> {
	
	@Inject extension IQualifiedNameProvider
	
	/**
	 * This method fills the List&ltTypedElement> imports (where are the typed elements to<br>
	 * go in the routes) and the Set&ltEntity> entitySubGroup (where are the referenced entities<br>
	 * in the routes).
	 * @param lc Controller list to make the Routes archive
	 * */
	override preprocess(List<CompositeTypeSpecification> list){

	}
	
	/**
	 * This method makes the C# project File with a list of ISML controllers, pages, models.
	 * @param e the controller list
	 * @return the C# Routes archive
	 * */
	override protected  template(List<CompositeTypeSpecification> e) '''
	<?xml version="1.0" encoding="utf-8"?>
	<Project ToolsVersion="15.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
	  <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
	  <PropertyGroup>
	    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
	    <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
	    <ProjectGuid>{9D125B16-096F-4D01-B220-7C7124833F4C}</ProjectGuid>
	    <OutputType>Library</OutputType>
	    <AppDesignerFolder>Properties</AppDesignerFolder>
	    <RootNamespace>AplicacionWeb.Models</RootNamespace>
	    <AssemblyName>AplicacionWeb.Models</AssemblyName>
	    <TargetFrameworkVersion>v4.5.2</TargetFrameworkVersion>
	    <FileAlignment>512</FileAlignment>
	  </PropertyGroup>
	  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
	    <DebugSymbols>true</DebugSymbols>
	    <DebugType>full</DebugType>
	    <Optimize>false</Optimize>
	    <OutputPath>bin\Debug\</OutputPath>
	    <DefineConstants>DEBUG;TRACE</DefineConstants>
	    <ErrorReport>prompt</ErrorReport>
	    <WarningLevel>4</WarningLevel>
	  </PropertyGroup>
	  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
	    <DebugType>pdbonly</DebugType>
	    <Optimize>true</Optimize>
	    <OutputPath>bin\Release\</OutputPath>
	    <DefineConstants>TRACE</DefineConstants>
	    <ErrorReport>prompt</ErrorReport>
	    <WarningLevel>4</WarningLevel>
	  </PropertyGroup>
	  <ItemGroup>
	    <Reference Include="System" />
	    <Reference Include="System.ComponentModel.DataAnnotations" />
	    <Reference Include="System.Core" />
	    <Reference Include="System.Xml.Linq" />
	    <Reference Include="System.Data.DataSetExtensions" />
	    <Reference Include="Microsoft.CSharp" />
	    <Reference Include="System.Data" />
	    <Reference Include="System.Net.Http" />
	    <Reference Include="System.Xml" />
	  </ItemGroup>
	  <ItemGroup>
	    <Compile Include="Entity.cs" />
	    «FOR item: e»
	    	«IF item instanceof Entity »
	    		<Compile Include="«item.name».cs" />
	    	«ENDIF»
	    «ENDFOR»
	  </ItemGroup>
	  <Import Project="$(MSBuildToolsPath)\Microsoft.CSharp.targets" />
	</Project>
	'''
	/**
	 * This method formats a parameter list from an Action for put them in the action's relative URL.
	 * @param action a Controller Action
	 * @return formatted string for the parameters
	 * */
	def CharSequence generateParameters(Action action) {
		var CharSequence cs= ''''''
		if(action.parameters.size>0){
			cs='''«FOR param: action.parameters»/{«param.name»}«ENDFOR»'''
		}
		else
			return cs
	}
	
}
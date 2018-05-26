package co.edu.javeriana.dotnetgenerator.templates

import co.edu.javeriana.isml.generator.common.SimpleTemplate
import co.edu.javeriana.isml.isml.Action
import co.edu.javeriana.isml.isml.Controller
import co.edu.javeriana.isml.isml.Entity
import com.google.inject.Inject
import java.util.List
import org.eclipse.xtext.naming.IQualifiedNameProvider
import co.edu.javeriana.isml.isml.CompositeTypeSpecification
import co.edu.javeriana.isml.isml.Page
import co.edu.javeriana.isml.isml.Service

class ProjectFileTemplateDAL extends SimpleTemplate<List<CompositeTypeSpecification>> {
	
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
	    <ProjectGuid>{1C085B80-88DD-4A61-9BCC-D5ACA41BCCF5}</ProjectGuid>
	    <OutputType>Library</OutputType>
	    <AppDesignerFolder>Properties</AppDesignerFolder>
	    <RootNamespace>AplicacionWeb.DAL</RootNamespace>
	    <AssemblyName>AplicacionWeb.DAL</AssemblyName>
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
	    <Reference Include="EntityFramework, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089, processorArchitecture=MSIL">
	      <HintPath>..\packages\EntityFramework.6.2.0\lib\net45\EntityFramework.dll</HintPath>
	    </Reference>
	    <Reference Include="EntityFramework.SqlServer, Version=6.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089, processorArchitecture=MSIL">
	      <HintPath>..\packages\EntityFramework.6.2.0\lib\net45\EntityFramework.SqlServer.dll</HintPath>
	    </Reference>
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
	    <Compile Include="ApplicationDbContext.cs" />
	    <Compile Include="IPersistence.cs" />
	    <Compile Include="Migrations\Configuration.cs" />
	    <Compile Include="Persistence.cs" />
	    <Compile Include="Properties\AssemblyInfo.cs" />
	  </ItemGroup>
	  <ItemGroup>
	    <ProjectReference Include="..\AplicacionWeb.Models\AplicacionWeb.Models.csproj">
	      <Project>{9d125b16-096f-4d01-b220-7c7124833f4c}</Project>
	      <Name>AplicacionWeb.Models</Name>
	    </ProjectReference>
	  </ItemGroup>
	  <ItemGroup>
	    <None Include="App.config" />
	    <None Include="packages.config" />
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
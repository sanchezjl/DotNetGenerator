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

class ProjectFileTemplate extends SimpleTemplate<List<CompositeTypeSpecification>> {
	
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
	<Project ToolsVersion="15.0" DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
	  <Import Project="..\packages\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.1.0.3\build\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.props" Condition="Exists('..\packages\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.1.0.3\build\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.props')" />
	  <Import Project="..\packages\Microsoft.Net.Compilers.1.3.2\build\Microsoft.Net.Compilers.props" Condition="Exists('..\packages\Microsoft.Net.Compilers.1.3.2\build\Microsoft.Net.Compilers.props')" />
	  <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
	  <PropertyGroup>
	    <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
	    <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
	    <ProductVersion>
	    </ProductVersion>
	    <SchemaVersion>2.0</SchemaVersion>
	    <ProjectGuid>{078D9DE2-EB44-49AC-95C4-F8096FD11138}</ProjectGuid>
	    <ProjectTypeGuids>{349c5851-65df-11da-9384-00065b846f21};{fae04ec0-301f-11d3-bf4b-00c04f79efbc}</ProjectTypeGuids>
	    <OutputType>Library</OutputType>
	    <AppDesignerFolder>Properties</AppDesignerFolder>
	    <RootNamespace>AplicacionWeb</RootNamespace>
	    <AssemblyName>AplicacionWeb</AssemblyName>
	    <TargetFrameworkVersion>v4.5.2</TargetFrameworkVersion>
	    <MvcBuildViews>false</MvcBuildViews>
	    <UseIISExpress>true</UseIISExpress>
	    <IISExpressSSLPort />
	    <IISExpressAnonymousAuthentication />
	    <IISExpressWindowsAuthentication />
	    <IISExpressUseClassicPipelineMode />
	    <UseGlobalApplicationHostFile />
	    <NuGetPackageImportStamp>
	    </NuGetPackageImportStamp>
	  </PropertyGroup>
	  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
	    <DebugSymbols>true</DebugSymbols>
	    <DebugType>full</DebugType>
	    <Optimize>false</Optimize>
	    <OutputPath>bin\</OutputPath>
	    <DefineConstants>DEBUG;TRACE</DefineConstants>
	    <ErrorReport>prompt</ErrorReport>
	    <WarningLevel>4</WarningLevel>
	  </PropertyGroup>
	  <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
	    <DebugSymbols>true</DebugSymbols>
	    <DebugType>pdbonly</DebugType>
	    <Optimize>true</Optimize>
	    <OutputPath>bin\</OutputPath>
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
	    <Reference Include="Microsoft.CodeDom.Providers.DotNetCompilerPlatform, Version=1.0.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <HintPath>..\packages\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.1.0.3\lib\net45\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.CSharp" />
	    <Reference Include="SimpleInjector, Version=4.2.1.0, Culture=neutral, PublicKeyToken=984cb50dea722e99, processorArchitecture=MSIL">
	      <HintPath>..\packages\SimpleInjector.4.2.1\lib\net45\SimpleInjector.dll</HintPath>
	    </Reference>
	    <Reference Include="SimpleInjector.Integration.Web, Version=4.2.1.0, Culture=neutral, PublicKeyToken=984cb50dea722e99, processorArchitecture=MSIL">
	      <HintPath>..\packages\SimpleInjector.Integration.Web.4.2.1\lib\net40\SimpleInjector.Integration.Web.dll</HintPath>
	    </Reference>
	    <Reference Include="SimpleInjector.Integration.Web.Mvc, Version=4.2.1.0, Culture=neutral, PublicKeyToken=984cb50dea722e99, processorArchitecture=MSIL">
	      <HintPath>..\packages\SimpleInjector.Integration.Web.Mvc.4.2.1\lib\net40\SimpleInjector.Integration.Web.Mvc.dll</HintPath>
	    </Reference>
	    <Reference Include="System" />
	    <Reference Include="System.Data" />
	    <Reference Include="System.Drawing" />
	    <Reference Include="System.Web.DynamicData" />
	    <Reference Include="System.Web.Entity" />
	    <Reference Include="System.Web.ApplicationServices" />
	    <Reference Include="System.ComponentModel.DataAnnotations" />
	    <Reference Include="System.Core" />
	    <Reference Include="System.Data.DataSetExtensions" />
	    <Reference Include="System.Xml.Linq" />
	    <Reference Include="System.Web" />
	    <Reference Include="System.Web.Extensions" />
	    <Reference Include="System.Web.Abstractions" />
	    <Reference Include="System.Web.Routing" />
	    <Reference Include="System.Xml" />
	    <Reference Include="System.Configuration" />
	    <Reference Include="System.Web.Services" />
	    <Reference Include="System.EnterpriseServices" />
	    <Reference Include="Microsoft.Web.Infrastructure, Version=1.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <Private>True</Private>
	      <HintPath>..\packages\Microsoft.Web.Infrastructure.1.0.0.0\lib\net40\Microsoft.Web.Infrastructure.dll</HintPath>
	    </Reference>
	    <Reference Include="System.Net.Http">
	    </Reference>
	    <Reference Include="System.Net.Http.WebRequest">
	    </Reference>
	    <Reference Include="System.Web.Helpers, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <Private>True</Private>
	      <HintPath>..\packages\Microsoft.AspNet.WebPages.3.2.3\lib\net45\System.Web.Helpers.dll</HintPath>
	    </Reference>
	    <Reference Include="System.Web.Mvc, Version=5.2.3.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <Private>True</Private>
	      <HintPath>..\packages\Microsoft.AspNet.Mvc.5.2.3\lib\net45\System.Web.Mvc.dll</HintPath>
	    </Reference>
	    <Reference Include="System.Web.Optimization">
	      <HintPath>..\packages\Microsoft.AspNet.Web.Optimization.1.1.3\lib\net40\System.Web.Optimization.dll</HintPath>
	    </Reference>
	    <Reference Include="System.Web.Razor, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <Private>True</Private>
	      <HintPath>..\packages\Microsoft.AspNet.Razor.3.2.3\lib\net45\System.Web.Razor.dll</HintPath>
	    </Reference>
	    <Reference Include="System.Web.WebPages, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <Private>True</Private>
	      <HintPath>..\packages\Microsoft.AspNet.WebPages.3.2.3\lib\net45\System.Web.WebPages.dll</HintPath>
	    </Reference>
	    <Reference Include="System.Web.WebPages.Deployment, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <Private>True</Private>
	      <HintPath>..\packages\Microsoft.AspNet.WebPages.3.2.3\lib\net45\System.Web.WebPages.Deployment.dll</HintPath>
	    </Reference>
	    <Reference Include="System.Web.WebPages.Razor, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35, processorArchitecture=MSIL">
	      <Private>True</Private>
	      <HintPath>..\packages\Microsoft.AspNet.WebPages.3.2.3\lib\net45\System.Web.WebPages.Razor.dll</HintPath>
	    </Reference>
	    <Reference Include="WebActivator, Version=1.4.4.0, Culture=neutral, processorArchitecture=MSIL">
	      <HintPath>..\packages\WebActivator.1.4.4\lib\net40\WebActivator.dll</HintPath>
	    </Reference>
	    <Reference Include="WebGrease">
	      <Private>True</Private>
	      <HintPath>..\packages\WebGrease.1.5.2\lib\WebGrease.dll</HintPath>
	    </Reference>
	    <Reference Include="Antlr3.Runtime">
	      <Private>True</Private>
	      <HintPath>..\packages\Antlr.3.4.1.9004\lib\Antlr3.Runtime.dll</HintPath>
	    </Reference>
	  </ItemGroup>
	  <ItemGroup>
	    <Reference Include="Newtonsoft.Json">
	      <HintPath>..\packages\Newtonsoft.Json.6.0.4\lib\net45\Newtonsoft.Json.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.ApplicationInsights">
	      <HintPath>..\packages\Microsoft.ApplicationInsights.2.2.0\lib\net45\Microsoft.ApplicationInsights.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.AI.Agent.Intercept">
	      <HintPath>..\packages\Microsoft.ApplicationInsights.Agent.Intercept.2.0.6\lib\net45\Microsoft.AI.Agent.Intercept.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.AI.DependencyCollector">
	      <HintPath>..\packages\Microsoft.ApplicationInsights.DependencyCollector.2.2.0\lib\net45\Microsoft.AI.DependencyCollector.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.AI.PerfCounterCollector">
	      <HintPath>..\packages\Microsoft.ApplicationInsights.PerfCounterCollector.2.2.0\lib\net45\Microsoft.AI.PerfCounterCollector.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.AI.ServerTelemetryChannel">
	      <HintPath>..\packages\Microsoft.ApplicationInsights.WindowsServer.TelemetryChannel.2.2.0\lib\net45\Microsoft.AI.ServerTelemetryChannel.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.AI.WindowsServer">
	      <HintPath>..\packages\Microsoft.ApplicationInsights.WindowsServer.2.2.0\lib\net45\Microsoft.AI.WindowsServer.dll</HintPath>
	    </Reference>
	    <Reference Include="Microsoft.AI.Web">
	      <HintPath>..\packages\Microsoft.ApplicationInsights.Web.2.2.0\lib\net45\Microsoft.AI.Web.dll</HintPath>
	    </Reference>
	  </ItemGroup>
	  <ItemGroup>
	    <Compile Include="App_Start\BundleConfig.cs" />
	    <Compile Include="App_Start\FilterConfig.cs" />
	    <Compile Include="App_Start\RouteConfig.cs" />
	    <Compile Include="App_Start\SimpleInjectorInitializer.cs" />
	    «FOR item: e»
	    	«IF item instanceof Controller && !item.name.equals("DefaultPageDispatcher") && !item.name.equals("AnyController")»
	    		<Compile Include="Controllers\«item.name».cs" />
	    	«ENDIF»
	    «ENDFOR»
	    <Compile Include="Global.asax.cs">
	      <DependentUpon>Global.asax</DependentUpon>
	    </Compile>
	    <Compile Include="Properties\AssemblyInfo.cs" />	    
	  </ItemGroup>
	  <ItemGroup>
	    <Content Include="Content\bootstrap.css" />
	    <Content Include="Content\bootstrap.min.css" />
	    <Content Include="favicon.ico" />
	    <Content Include="fonts\glyphicons-halflings-regular.svg" />
	    <Content Include="Global.asax" />
	    <Content Include="Content\Site.css" />
	    <Content Include="Scripts\bootstrap.js" />
	    <Content Include="Scripts\bootstrap.min.js" />
	    <Content Include="ApplicationInsights.config">
	      <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
	    </Content>
	    <None Include="Scripts\jquery-1.10.2.intellisense.js" />
	    <Content Include="Scripts\jquery-1.10.2.js" />
	    <Content Include="Scripts\jquery-1.10.2.min.js" />
	    <None Include="Scripts\jquery.validate-vsdoc.js" />
	    <Content Include="Scripts\jquery.validate.js" />
	    <Content Include="Scripts\jquery.validate.min.js" />
	    <Content Include="Scripts\jquery.validate.unobtrusive.js" />
	    <Content Include="Scripts\jquery.validate.unobtrusive.min.js" />
	    <Content Include="Scripts\modernizr-2.6.2.js" />
	    <Content Include="Scripts\respond.js" />
	    <Content Include="Scripts\respond.min.js" />
	    <Content Include="Web.config" />
	    <Content Include="Web.Debug.config">
	      <DependentUpon>Web.config</DependentUpon>
	    </Content>
	    <Content Include="Web.Release.config">
	      <DependentUpon>Web.config</DependentUpon>
	    </Content>
	    <Content Include="Views\Web.config" />
	    <Content Include="Views\_ViewStart.cshtml" />
	    <Content Include="Views\Shared\Error.cshtml" />
	    <Content Include="Views\Shared\_Layout.cshtml" />
	    <Content Include="Views\Shared\DisplayTemplates\DateTime.cshtml" />
		«FOR item: e»
		«IF item instanceof Page && !item.name.equals("AnyPage") »			
		<Content Include="Views\«item.eContainer?.fullyQualifiedName.toString("/").toFirstUpper»\«item.name».cshtml" />
		«ENDIF»
		«ENDFOR»
	  </ItemGroup>
	  <ItemGroup>
	    <Folder Include="App_Data\" />
	  </ItemGroup>
	  <ItemGroup>
	    <Content Include="fonts\glyphicons-halflings-regular.woff" />
	  </ItemGroup>
	  <ItemGroup>
	    <Content Include="fonts\glyphicons-halflings-regular.ttf" />
	  </ItemGroup>
	  <ItemGroup>
	    <Content Include="fonts\glyphicons-halflings-regular.eot" />
	  </ItemGroup>
	  <ItemGroup>
	    <Content Include="packages.config" />
	  </ItemGroup>
	  <ItemGroup>
	    <Content Include="Scripts\jquery-1.10.2.min.map" />
	  </ItemGroup>
	  <ItemGroup>
	    <ProjectReference Include="..\AplicacionWeb.DAL\AplicacionWeb.DAL.csproj">
	      <Project>{1c085b80-88dd-4a61-9bcc-d5aca41bccf5}</Project>
	      <Name>AplicacionWeb.DAL</Name>
	    </ProjectReference>
	    <ProjectReference Include="..\AplicacionWeb.Models\AplicacionWeb.Models.csproj">
	      <Project>{9d125b16-096f-4d01-b220-7c7124833f4c}</Project>
	      <Name>AplicacionWeb.Models</Name>
	    </ProjectReference>
	    <ProjectReference Include="..\AplicacionWeb.Services\AplicacionWeb.Services.csproj">
	      <Project>{ed2685d6-9897-4ef0-8529-63784b669016}</Project>
	      <Name>AplicacionWeb.Services</Name>
	    </ProjectReference>
	  </ItemGroup>	  
	  <PropertyGroup>
	    <VisualStudioVersion Condition="'$(VisualStudioVersion)' == ''">10.0</VisualStudioVersion>
	    <VSToolsPath Condition="'$(VSToolsPath)' == ''">$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v$(VisualStudioVersion)</VSToolsPath>
	  </PropertyGroup>
	  <Import Project="$(MSBuildBinPath)\Microsoft.CSharp.targets" />
	  <Import Project="$(VSToolsPath)\WebApplications\Microsoft.WebApplication.targets" Condition="'$(VSToolsPath)' != ''" />
	  <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v10.0\WebApplications\Microsoft.WebApplication.targets" Condition="false" />
	  <Target Name="MvcBuildViews" AfterTargets="AfterBuild" Condition="'$(MvcBuildViews)'=='true'">
	    <AspNetCompiler VirtualPath="temp" PhysicalPath="$(WebProjectOutputDir)" />
	  </Target>
	  <ProjectExtensions>
	    <VisualStudio>
	      <FlavorProperties GUID="{349c5851-65df-11da-9384-00065b846f21}">
	        <WebProjectProperties>
	          <UseIIS>True</UseIIS>
	          <AutoAssignPort>True</AutoAssignPort>
	          <DevelopmentServerPort>57832</DevelopmentServerPort>
	          <DevelopmentServerVPath>/</DevelopmentServerVPath>
	          <IISUrl>http://localhost:57832/</IISUrl>
	          <NTLMAuthentication>False</NTLMAuthentication>
	          <UseCustomServer>False</UseCustomServer>
	          <CustomServerUrl>
	          </CustomServerUrl>
	          <SaveServerSettingsInUserFile>False</SaveServerSettingsInUserFile>
	        </WebProjectProperties>
	      </FlavorProperties>
	    </VisualStudio>
	  </ProjectExtensions>
	  <Target Name="EnsureNuGetPackageBuildImports" BeforeTargets="PrepareForBuild">
	    <PropertyGroup>
	      <ErrorText>Este proyecto hace referencia a los paquetes NuGet que faltan en este equipo. Use la restauración de paquetes NuGet para descargarlos. Para obtener más información, consulte http://go.microsoft.com/fwlink/?LinkID=322105. El archivo que falta es {0}.</ErrorText>
	    </PropertyGroup>
	    <Error Condition="!Exists('..\packages\Microsoft.Net.Compilers.1.3.2\build\Microsoft.Net.Compilers.props')" Text="$([System.String]::Format('$(ErrorText)', '..\packages\Microsoft.Net.Compilers.1.3.2\build\Microsoft.Net.Compilers.props'))" />
	    <Error Condition="!Exists('..\packages\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.1.0.3\build\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.props')" Text="$([System.String]::Format('$(ErrorText)', '..\packages\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.1.0.3\build\Microsoft.CodeDom.Providers.DotNetCompilerPlatform.props'))" />
	  </Target>
	  <!-- To modify your build process, add your task inside one of the targets below and uncomment it.
	       Other similar extension points exist, see Microsoft.Common.targets.
	  <Target Name="BeforeBuild">
	  </Target>
	  <Target Name="AfterBuild">
	  </Target> -->
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
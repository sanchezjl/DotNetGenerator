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
            
		    container.Register<IPersistence<Ciudad>, Persistence<Ciudad>>(Lifestyle.Scoped);
		    container.Register<IPersistence<Genero>, Persistence<Genero>>(Lifestyle.Scoped);
		    container.Register<IPersistence<Cliente>, Persistence<Cliente>>(Lifestyle.Scoped);
		    container.Register<IPersistence<Departamento>, Persistence<Departamento>>(Lifestyle.Scoped);
		    container.Register<IPersistence<Pais>, Persistence<Pais>>(Lifestyle.Scoped);
		    container.Register<IPersistence<RegistroPago>, Persistence<RegistroPago>>(Lifestyle.Scoped);
		    container.Register<IPersistence<Producto>, Persistence<Producto>>(Lifestyle.Scoped);
		    container.Register<IPersistence<Tipo_Producto>, Persistence<Tipo_Producto>>(Lifestyle.Scoped);
		    container.Register<IPersistence<Venta>, Persistence<Venta>>(Lifestyle.Scoped);
		    container.Register<IPersistence<VentaArticulos>, Persistence<VentaArticulos>>(Lifestyle.Scoped);
		    
			container.Register<IServicioFidelizacion<Ciudad>, ServicioFidelizacion<Ciudad>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<Genero>, ServicioFidelizacion<Genero>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<Cliente>, ServicioFidelizacion<Cliente>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<Departamento>, ServicioFidelizacion<Departamento>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<Pais>, ServicioFidelizacion<Pais>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<RegistroPago>, ServicioFidelizacion<RegistroPago>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<Producto>, ServicioFidelizacion<Producto>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<Tipo_Producto>, ServicioFidelizacion<Tipo_Producto>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<Venta>, ServicioFidelizacion<Venta>>(Lifestyle.Scoped);
			container.Register<IServicioFidelizacion<VentaArticulos>, ServicioFidelizacion<VentaArticulos>>(Lifestyle.Scoped);
			
			container.Register<IServicioEntregaDomicilio<Ciudad>, ServicioEntregaDomicilio<Ciudad>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<Genero>, ServicioEntregaDomicilio<Genero>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<Cliente>, ServicioEntregaDomicilio<Cliente>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<Departamento>, ServicioEntregaDomicilio<Departamento>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<Pais>, ServicioEntregaDomicilio<Pais>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<RegistroPago>, ServicioEntregaDomicilio<RegistroPago>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<Producto>, ServicioEntregaDomicilio<Producto>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<Tipo_Producto>, ServicioEntregaDomicilio<Tipo_Producto>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<Venta>, ServicioEntregaDomicilio<Venta>>(Lifestyle.Scoped);
			container.Register<IServicioEntregaDomicilio<VentaArticulos>, ServicioEntregaDomicilio<VentaArticulos>>(Lifestyle.Scoped);
			
			container.Register<IServicioPagos<Ciudad>, ServicioPagos<Ciudad>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<Genero>, ServicioPagos<Genero>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<Cliente>, ServicioPagos<Cliente>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<Departamento>, ServicioPagos<Departamento>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<Pais>, ServicioPagos<Pais>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<RegistroPago>, ServicioPagos<RegistroPago>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<Producto>, ServicioPagos<Producto>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<Tipo_Producto>, ServicioPagos<Tipo_Producto>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<Venta>, ServicioPagos<Venta>>(Lifestyle.Scoped);
			container.Register<IServicioPagos<VentaArticulos>, ServicioPagos<VentaArticulos>>(Lifestyle.Scoped);
			
        }
    }
}
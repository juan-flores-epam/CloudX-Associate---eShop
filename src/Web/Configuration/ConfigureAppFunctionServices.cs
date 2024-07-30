using Microsoft.eShopWeb.ApplicationCore.Interfaces;
using Microsoft.eShopWeb.ApplicationCore.Services;

namespace Microsoft.eShopWeb.Web.Configuration;

public static class ConfigureAppFunctionServices
{

    public static IServiceCollection AddAppFunctionServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddItemsReserverFunction(configuration);
        return services;
    }

    private static IServiceCollection AddItemsReserverFunction(this IServiceCollection services, IConfiguration configuration)
    {
        var catalogSettings = configuration.Get<AppFunctionSettings>() ?? new AppFunctionSettings();
        var url = catalogSettings?.ReserverUrl ?? string.Empty;
        services.AddHttpClient("ReserverFunction", httpClient => 
        {
            httpClient.BaseAddress = new Uri(url);
        });
        services.AddScoped<IAppFunctionService, AppFunctionService>();
        return services;
    }
}

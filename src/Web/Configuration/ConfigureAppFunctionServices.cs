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
        var appFunctions = configuration.GetRequiredSection(AppFunctionSettings.CONFIG_NAME).Get<AppFunctionSettings>();
        var url = appFunctions?.ReserverUrl ?? string.Empty;
        services.AddHttpClient("ReserverFunction", httpClient => 
        {
            httpClient.BaseAddress = new Uri(url);
        });
        services.AddScoped<IAppFunctionService, AppFunctionService>();
        return services;
    }
}

using Microsoft.eShopWeb.ApplicationCore.Interfaces;
using Microsoft.eShopWeb.ApplicationCore.Services;

namespace Microsoft.eShopWeb.Web.Configuration;

public static class ConfigureAppFunctionServices
{

    public static IServiceCollection AddAppFunctionServices(this IServiceCollection services, IConfiguration configuration)
    {
        services.AddItemsReserverFunction(configuration);
        services.AddDeliveryServiceFunction(configuration);
        return services;
    }

    private static IServiceCollection AddItemsReserverFunction(this IServiceCollection services, IConfiguration configuration)
    {
        var appFuncSettings = configuration.GetRequiredSection(AppFunctionSettings.CONFIG_NAME).Get<AppFunctionSettings>();
        var url = appFuncSettings?.URL ?? string.Empty;
        var appName = appFuncSettings?.AppName ?? string.Empty;
        services.AddHttpClient(appName, httpClient => 
        {
            httpClient.BaseAddress = new Uri($"{url}");
        });
        services.AddScoped<IAppFunctionService, AppFunctionService>();
        return services;
    }

    private static IServiceCollection AddDeliveryServiceFunction(this IServiceCollection services, IConfiguration configuration)
    {
        var appFuncSettings = configuration.GetRequiredSection(AppFunctionSettings.CONFIG_NAME).Get<AppFunctionSettings>();
        var url = appFuncSettings?.DeliveryServiceFuntionAppUrl ?? string.Empty;
        var appName = appFuncSettings?.DeliveryServiceEndpointName ?? string.Empty;
        services.AddHttpClient(appName, httpClient =>
        {
            httpClient.BaseAddress = new Uri($"{url}");
        });
        services.AddScoped<IAppFunctionService, AppFunctionService>();
        return services;
    }
}

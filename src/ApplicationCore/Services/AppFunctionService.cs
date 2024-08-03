using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.eShopWeb.ApplicationCore.Entities.BasketAggregate;
using Microsoft.eShopWeb.ApplicationCore.Entities.OrderAggregate;
using Microsoft.eShopWeb.ApplicationCore.Interfaces;
using Microsoft.eShopWeb.ApplicationCore.Specifications;
using Microsoft.Extensions.Options;

namespace Microsoft.eShopWeb.ApplicationCore.Services;

public class AppFunctionService : IAppFunctionService
{
    private readonly IRepository<Order> _orderRepository;
    private readonly IHttpClientFactory _httpClientFactory;
    private readonly AppFunctionSettings _appFuncSettings;

    public AppFunctionService(IRepository<Order> basketRepository, IHttpClientFactory httpClientFactory, IOptions<AppFunctionSettings> appFuncSettings)
    {
        _orderRepository = basketRepository;
        _httpClientFactory = httpClientFactory;
        _appFuncSettings = appFuncSettings.Value;
    }

    public async Task UploadOrderToStorage(int orderId)
    {
        var orderSpec = new OrderWithItemsByIdSpec(orderId);
        var order = await _orderRepository.FirstOrDefaultAsync(orderSpec);
        // var basket = await _baseketRepository.FirstOrDefaultAsync(basketSpec);
        var content = JsonSerializer.Serialize(order);
        var httpClient = _httpClientFactory.CreateClient(_appFuncSettings.AppName);
        var response = await httpClient.PostAsync(
            $"{_appFuncSettings.ReserverEndpointName}?name=order{orderId}-{order?.BuyerId}-{order?.OrderDate}", 
            new StringContent(content, Encoding.UTF8, @"application/json")
        );
    }
}
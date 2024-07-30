using System.Net.Http;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;
using Microsoft.eShopWeb.ApplicationCore.Entities.BasketAggregate;
using Microsoft.eShopWeb.ApplicationCore.Interfaces;
using Microsoft.eShopWeb.ApplicationCore.Specifications;

namespace Microsoft.eShopWeb.ApplicationCore.Services;

public class AppFunctionService : IAppFunctionService
{
    private readonly IRepository<Basket> _baseketRepository;
    private readonly IHttpClientFactory _httpClientFactory;

    public AppFunctionService(IRepository<Basket> basketRepository, IHttpClientFactory httpClientFactory)
    {
        _baseketRepository = basketRepository;
        _httpClientFactory = httpClientFactory;
    }

    public async Task UploadOrderToStorage(int baskedId)
    {
        var basketSpec = new BasketWithItemsSpecification(baskedId);
        var basket = await _baseketRepository.FirstOrDefaultAsync(basketSpec);
        var content = JsonSerializer.Serialize(basket);
        var httpClient = _httpClientFactory.CreateClient("ReserverFunction");
        var response = await httpClient.PostAsync("", new StringContent(content, Encoding.UTF8, @"application/json"));
    }
}
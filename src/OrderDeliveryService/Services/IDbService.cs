using Microsoft.Azure.Cosmos;

namespace OrderDeliveryService.Services;
public interface IDbService
{
    public Task Initialize();
    Container GetContainer();
}

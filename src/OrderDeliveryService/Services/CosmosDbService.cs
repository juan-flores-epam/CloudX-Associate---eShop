using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.Cosmos;

namespace OrderDeliveryService.Services;
public class CosmosDbService : IDbService
{
    private readonly string EndpointUri = "https://cosmosdb-jcfs-cloudx-centralus.documents.azure.com:443/";
    private readonly string PrimaryKey = "kCSHrPWRQA0zCu7YfnVMvwATbUkXEvSy1CMEXbIjiqFasvu2psIrakJTgulmBZAQNzas5j9gP02PACDbyuzzpQ==";

    private CosmosClient _cosmosClient;
    private Database _database;
    private Microsoft.Azure.Cosmos.Container _container;

    private string _databaseId = "delivery";
    private string _containerId = "orders";

    public string Container => _containerId;

    public async Task Initialize()
    {
        _cosmosClient = new CosmosClient(EndpointUri, PrimaryKey);
        await CreateDatabaseAsync();
        await CreateContainerAsync();
    }

    public Microsoft.Azure.Cosmos.Container GetContainer()
    {
        return _container;
    }

    private async Task CreateDatabaseAsync()
    {
        _database = await _cosmosClient.CreateDatabaseIfNotExistsAsync(_databaseId);
        Console.WriteLine("Created Database: {0}\n", _database.Id);
    }
    private async Task CreateContainerAsync()
    {
        _container = await _database.CreateContainerIfNotExistsAsync(_containerId, "/newOrders");
        Console.WriteLine("Created Container: {0}\n", _container.Id);
    }
}

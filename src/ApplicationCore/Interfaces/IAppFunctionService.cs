using System.Threading.Tasks;
namespace Microsoft.eShopWeb.ApplicationCore.Interfaces;

public interface IAppFunctionService {
    Task UploadOrderToStorage(int baskedId);
}
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using veritaban.DAL;
using veritaban.Models;

namespace veritaban.Repositories
{
    public class ProductRepository : IRepository<Product>
    {
        private readonly SalesDbContext _context;

        public ProductRepository()
        {
            _context = new SalesDbContext();
        }

        public async Task<IEnumerable<Product>> GetAllAsync()
        {
            return await _context.Products.SqlQuery("SELECT * FROM Products").ToListAsync();
        }

        public async Task<Product> GetByIdAsync(string id)
        {
            return await _context.Products.SqlQuery("EXEC ViewProductDetails @ProductID", new SqlParameter("@ProductID", id)).FirstOrDefaultAsync();
        }

        public async Task AddAsync(Product product)
        {
            await _context.Database.ExecuteSqlCommandAsync("EXEC AddProduct @ProductID, @ProductName, @Category, @UnitPrice, @Description, @StockQuantity, @Unit",
                new SqlParameter("@ProductID", product.ProductID),
                new SqlParameter("@ProductName", product.ProductName),
                new SqlParameter("@Category", product.Category),
                new SqlParameter("@UnitPrice", product.UnitPrice),
                new SqlParameter("@Description", product.Description),
                new SqlParameter("@StockQuantity", product.StockQuantity),
                new SqlParameter("@Unit", product.Unit));
        }

        public async Task UpdateAsync(Product product)
        {
            await _context.Database.ExecuteSqlCommandAsync("EXEC UpdateProduct @ProductID, @ProductName, @Category, @UnitPrice, @Description, @StockQuantity, @Unit",
                new SqlParameter("@ProductID", product.ProductID),
                new SqlParameter("@ProductName", product.ProductName),
                new SqlParameter("@Category", product.Category),
                new SqlParameter("@UnitPrice", product.UnitPrice),
                new SqlParameter("@Description", product.Description),
                new SqlParameter("@StockQuantity", product.StockQuantity),
                new SqlParameter("@Unit", product.Unit));
        }

        public async Task DeleteAsync(string id)
        {
            await _context.Database.ExecuteSqlCommandAsync("EXEC DeleteProduct @ProductID", new SqlParameter("@ProductID", id));
        }
    }
}
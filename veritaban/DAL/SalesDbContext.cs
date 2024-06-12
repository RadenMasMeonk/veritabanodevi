using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using veritaban.Models;

namespace veritaban.DAL
{
    public class SalesDbContext : DbContext
    {
        public SalesDbContext() : base("name=SalesDbContext")
        {
        }

        public DbSet<Customer> Customers { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Sale> Sales { get; set; }
        public DbSet<Payment> Payments { get; set; }
    }
}
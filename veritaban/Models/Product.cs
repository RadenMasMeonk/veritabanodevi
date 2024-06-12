using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace veritaban.Models
{
    public class Product
    {
        public string ProductID { get; set; }
        public string ProductName { get; set; }
        public string Category { get; set; }
        public float UnitPrice { get; set; }
        public string Description { get; set; }
        public float StockQuantity { get; set; }
        public string Unit { get; set; }
    }
}
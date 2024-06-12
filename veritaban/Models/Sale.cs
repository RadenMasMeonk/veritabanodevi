using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace veritaban.Models
{
    public class Sale
    {
        public string SaleID { get; set; }
        public string CustomerID { get; set; }
        public string ProductID { get; set; }
        public DateTime SaleDate { get; set; }
        public float SalePrice { get; set; }
    }
}
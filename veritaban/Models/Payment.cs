using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace veritaban.Models
{
    public class Payment
    {
        public string PaymentID { get; set; }
        public string CustomerID { get; set; }
        public DateTime PaymentDate { get; set; }
        public float PaymentAmount { get; set; }
        public string PaymentMethod { get; set; }
        public string Description { get; set; }
    }
}
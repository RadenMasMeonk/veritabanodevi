using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using veritaban.Models;
using veritaban.Repositories;

namespace veritaban.Controllers
{
    [RoutePrefix("api/customers")]
    public class CustomerController : ApiController
    {
        private readonly IRepository<Customer> _repository;

        public CustomerController()
        {
            _repository = new CustomerRepository();
        }

        [HttpGet]
        [Route("")]
        public async Task<IHttpActionResult> GetCustomers()
        {
            var customers = await _repository.GetAllAsync();
            return Ok(customers);
        }

        [HttpGet]
        [Route("{id}")]
        public async Task<IHttpActionResult> GetCustomer(string id)
        {
            var customer = await _repository.GetByIdAsync(id);
            if (customer == null)
            {
                return NotFound();
            }
            return Ok(customer);
        }

        [HttpPost]
        [Route("")]
        public async Task<IHttpActionResult> CreateCustomer([FromBody] Customer customer)
        {
            await _repository.AddAsync(customer);
            return CreatedAtRoute("GetCustomer", new { id = customer.CustomerID }, customer);
        }

        [HttpPut]
        [Route("{id}")]
        public async Task<IHttpActionResult> UpdateCustomer(string id, [FromBody] Customer customer)
        {
            if (id != customer.CustomerID)
            {
                return BadRequest();
            }
            await _repository.UpdateAsync(customer);
            return StatusCode(HttpStatusCode.NoContent);
        }

        [HttpDelete]
        [Route("{id}")]
        public async Task<IHttpActionResult> DeleteCustomer(string id)
        {
            await _repository.DeleteAsync(id);
            return StatusCode(HttpStatusCode.NoContent);
        }
    }
}
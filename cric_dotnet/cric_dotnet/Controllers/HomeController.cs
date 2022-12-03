using cric_dotnet.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Google.Cloud.Firestore;

namespace cric_dotnet.Controllers
{
    public class HomeController : Controller
    {
        FirestoreDb database;
        [HttpGet("medicine/getAll")]
        public IActionResult GetAll()
        {
            test();
            var result = "jjjjjjjjjjjjuuuuuuuuuuuuuuuu";
            return Ok();
        }

        async void test() {
            

            database = FirestoreDb.Create("cricproject-b1fb5");

            DocumentReference docRef = database.Collection("Match").Document("6kIw6ojAJagergeZ7dpe");
            DocumentSnapshot snapshot = await docRef.GetSnapshotAsync();
            if (snapshot.Exists)
            {
                Console.WriteLine("Document data for {0} document:", snapshot.Id);
                Dictionary<string, object> city = snapshot.ToDictionary();
                foreach (KeyValuePair<string, object> pair in city)
                {
                    Console.WriteLine("{0}: {1}", pair.Key, pair.Value);
                }
            }
            else
            {
                Console.WriteLine("Document {0} does not exist!", snapshot.Id);
            }
        }
    }
}

using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using cric_dotnet.Models;
using cric_dotnet.Repository;

namespace cric_dotnet.Controllers
{
    public class MatchController : Controller
    {
        private readonly MatchRepository repository = new MatchRepository();


        [HttpGet("match/getMatchList")]
        public IActionResult GetMathList()
        {
            return Ok(repository.GetMatchList().Result);
        }


        [HttpGet("match/getMatchByMatchId")]
        public IActionResult GetAll(string matchId)
        {
            
            return Ok(repository.GetMatch(matchId).Result);
        }
    }
}

using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace webserver.Models
{
    // Contains custom data in the user model
    public class ApplicationUser : IdentityUser 
    {
        
        public string GamerTag { get; set; }
    }
}

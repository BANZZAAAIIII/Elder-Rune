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
        
       public List<DevBlog> DevBlogs { get; set; }
       public List<Player> players { get; set; }
    }
}

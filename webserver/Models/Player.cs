using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;


namespace webserver.Models
{
    public class Player
    {
        public Player() {}
    
        public Player(int xposition, int yposition)
        {
            x_position = xposition;
            y_position = yposition;

        }
        
        [Required] public int x_position{ get; set; }

        [Required] public int y_position{ get; set; }
        
        [Key]
        [Required] public string player_name{ get; set; }
        
        
        public virtual string ApplicationUserId { get; set; }
        [ForeignKey("ApplicationUserId")]
        public ApplicationUser ApplicationUser { get; set; }
    }
    
}
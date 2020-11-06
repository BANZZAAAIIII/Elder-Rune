using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Threading.Tasks;

namespace webserver.Models
{

    public class DevBlog
    {
        public DevBlog() { }

        public DevBlog(string title, string summary, string content)
        {
            Title = title;
            Summary = summary;
            Content = content;
            Time = DateTime.Now.Date;
        }

        // Constructor which takes time as parameter, primarly used for testing
        public DevBlog(string title, string summary, string content, DateTime time)
            : this(title, summary, content)
        {
            Time = time;
        }

        // Developer blog Id
        public int Id { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} and at max {1} characters long.", MinimumLength = 3)]
        [DisplayName("Title")]
        public string Title { get; set; }

        [Required]
        [StringLength(100, ErrorMessage = "The {0} must be at least {2} and at max {1} characters long.", MinimumLength = 3)]
        [DisplayName("Summary")]
        public string Summary { get; set; }

        [Required]
        [StringLength(5000, ErrorMessage = "The {0} must be at least {2} and at max {1} characters long.", MinimumLength = 3)]
        [DisplayName("Content")]
        public string Content { get; set; }

        [DataType(DataType.Date)]
        public DateTime Time { get; set; }


        //--------------------------Relations---------------------------------------
        public virtual string ApplicationUserId { get; set; }
        [ForeignKey("ApplicationUserId")]
        public ApplicationUser ApplicationUser { get; set; }
    }
}

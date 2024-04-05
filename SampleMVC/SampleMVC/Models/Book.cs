using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace SampleMVC.Models
{
    public class Book
    {
        [Key]
        public int SerialNumber { get; set; }
        public string? Name { get; set; }
        public string? Author { get; set; }
        public float Price { get; set; }
        public string? AssignedTo { get; set; }

        [DataType(DataType.Date)]
        [Column(TypeName = "date")]
        public DateTime? DateOfPublish { get; set; }
    }
}

'Use Strict'

$(document).ready(function () {

    let pageNumber = 1;
     
    $(".DevBlog").load("DevBlogs/GetDevBlog");
    $(".Previous").prop("disabled", true);

    $(".Previous").click(function () {
        if (pageNumber > 1) {
            pageNumber -= 1;
            console.log(`\DevBlogs/GetDevBlog/?pageNumber=${pageNumber}`)
            $(".DevBlog").load(`\DevBlogs/GetDevBlog/?pageNumber=${pageNumber}`);
            if (pageNumber <= 1) $(".Previous").prop("disabled", true);
        }
        return false;

    });

    // TODO: Add limit for number of times next can be pressed, dependent on number of posts available
    $(".Next").click(function () {
        pageNumber += 1;
        console.log(`\DevBlogs/GetDevBlog/?pageNumber=${pageNumber}`)
        $(".DevBlog").load(`\DevBlogs/GetDevBlog/?pageNumber=${pageNumber}`);
        if (pageNumber > 1)
            $(".Previous").prop("disabled", false);
        return false;
    });
   

    $("#test").click(function () {
        $(this).fadeOut();
        console.log("Clicked test")
    });
        
});
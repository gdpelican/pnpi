markdown_description = 
"You're able to add links, formatting, images, and whatever else you'd care to in this field \t[Learn how »](javascript:;)
          
 1. This field can be filled out using Markdown, which is a markup language that lets you write some simple formatted HTML, without having to learn (too much) pesky coding stuff.
    
    Some examples:
      
    * Single asterisks (\\*italic\\*) makes text *italic*
    * Double asterisks (\\*\\*bold\\\*\\*) makes text **bold**
    * \\[A link\\](http://www.google.com) turns into [A link](http://www.google.com)
      
    If you're interested, check out [this guide](http://support.iawriter.com/help/kb/general-questions/markdown-syntax-reference-guide) for some more advanced things you can do.
      
    If you're not, more power to you! Markdown will accept plain text just fine as well.
      
    Happy typing!"
    
INFO = {          
  person: {
    new:
      "Thanks for joining us! Please take a little time to tell us some basic information about yourself,
including your name, bio, and a quick quote to give us a feel for who are as an artist. A recent photograph is also highly recommended. 

Once you've been approved, you'll be able to search our database for fellow collaborators, as well as contribute work samples and/or props or venues 
you'd like to make available to the community. 

We look forward to hearing from you!",
    email: "Please enter your email address (you'll need this to sign up)",
    phone: "You may enter a contact number if you'd like people to be able to reach you by phone",
    website: "If you have a web home, enter it here.",
    description:
      "1. This is a more detailed description of yourself and your work. Feel free to type up a resume, or a longer artistic statement,
          or otherwise let us know what you want us to know about you.
          
      #{markdown_description}",
    
    preview:
    "Please provide a short artistic statement, maximum 140 characters. This is your elevator speech; what is it that you do best, or most appeals to you about your work?",
    
    jobs:
    "Please select up to 3 jobs you'd like to list yourself as. We know you probably wear a lot of hats, so it's best to choose ones
    you consider yourself most proficient in or best known for.",
    
    company_affiliation:
    "Select any companies you are affiliated with. Please note that these should not simply be companies you have worked for before,
    but ones you've donated a significant chunk of time, effort, or resources to, either onstage, backstage, administratively, or otherwise."
  
  },
  
  place: {
    new:
      "Have a space you're interested in sharing or renting out to the community? 

Take a little time to provide a name, address, and description of the place, as well as any other relevant details.

You will be listed as the point of contact for this space.",
    name: "The name of your venue or event space. Please be descriptive! (Especially if you are listing multiple spaces within the same building.",
    address: "The phsyical address of your venue.",
    description:
    "1. Please provide any relevant details about your venue, including square footage, floor plans, contact info, pricing info, 
        etc.
    
    #{markdown_description}",
  },
  
  thing: {
    new:
    "Is there a prop you'd be interested in making available? Let us know about it! 

Be sure to describe a short description and a photograph. Is it new or used? For rent? Is there a production the reader might recognize it from?
        
You can also either specify a rental rate (in $ per time period), or leave it blank if you're willing to lend it freely.",
    price: "The cost (in dollars) for renting this prop / set over the given time period",
    period: "The time period this prop / set piece is available is available for rental (ie a day? A month?)",
    description:
    "1. Provide additional details about this item.
    
    #{markdown_description}",  

    preview:
    "Provide a short description of your item; is it new or used? For rent? Is there a production the reader might recognize it from?"
  },
  
  sample: {
    new:
    "If you have a resume or work samples of some kind you'd like to share with potential collaborators, upload them here.
We accept documents, videos, pictures, pdfs, or you can simply give us a link to an existing site.

Currently supported upload file formats are .txt, .doc, .mp4, .docx, .jpeg, .jpg, and .pdf",
    link: "Please enter a web address to link to"
  }
}
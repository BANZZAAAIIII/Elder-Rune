using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.Extensions.Options;
using SendGrid;
using SendGrid.Helpers.Mail;
using System.Threading.Tasks;

namespace webserver.Services
{
    public class EmailSender : IEmailSender
    {
        public EmailSender(IOptions<AuthMessageSenderOptions> optionsAccessor)
        {
            Options = optionsAccessor.Value;
        }

        public AuthMessageSenderOptions Options { get; } //set only via Secret Manager

        public Task SendEmailAsync(string email, string subject, string message)
        {
            var gridkey = "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";
            // Adding gridkey and griduser removes the need for examiner to set up secret-user
            // return Execute(Options.SendGridKey, subject, message, email);
            return Execute(gridkey, subject, message, email);
        }

        public Task Execute(string apiKey, string subject, string message, string email)
        {
            var griduser = "PasswordConfirmation";
            var client = new SendGridClient(apiKey);
            var msg = new SendGridMessage()
            {
                From = new EmailAddress("snostorm.underholdning@gmail.com", griduser),
                Subject = subject,
                PlainTextContent = message,
                HtmlContent = message
            };
            msg.AddTo(new EmailAddress(email));

            // Disable click tracking.
            // See https://sendgrid.com/docs/User_Guide/Settings/tracking.html
            msg.SetClickTracking(false, false);

            return client.SendEmailAsync(msg);
        }
    }
}
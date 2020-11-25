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
            var griduser = "elruKey";
            var client = new SendGridClient(apiKey);
            var msg = new SendGridMessage()
            {
                From = new EmailAddress("hansgt14@uia.no", griduser),
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
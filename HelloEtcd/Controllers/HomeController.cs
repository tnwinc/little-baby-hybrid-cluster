using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNet.Mvc;

namespace HelloEtcd.Controllers
{
    public class HomeController : Controller
    {
        private string StringFromEtcd => "not real";
        private string OS => System.Environment.OSVersion.VersionString;

        public IActionResult Index()
        {
            ViewData["etcd"] = StringFromEtcd;
            ViewData["os"] = OS;
            return View();
        }

        public IActionResult Error()
        {
            return View("~/Views/Shared/Error.cshtml");
        }
    }
}

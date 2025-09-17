//script viết và triển khai qua google app script

var spreadsheetId = "google sheet id của bạn";
var lastUpdateTimestamp = 0;
var totalBalance ;
var recipientEmail = email của bạn"
var check = "https://adastat.net/accounts/....." // lấy đường link trong web để copy vào đây.
var currentTime = getCurrentTime();
var telegramBotToken = "Bot token của bạn";
var telegramChatId ="ID telegram group"; //add group với bot 
function soduADA() {
  // Define the recipient email
  var koiosUrl = "https://api.koios.rest/api/v1/account_info";
  var koiosHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "authorization": "Author token" 
  };

  // Define the Koios API request body
  var koiosBody = {
    "_stake_addresses": ["địa chỉ stake key của bạn"]
  };

  // Make the HTTP request to Koios API
  var koiosResponse = UrlFetchApp.fetch(koiosUrl, {
    method: "post",
    contentType: "application/json",
    headers: koiosHeaders,
    payload: JSON.stringify(koiosBody)
  });

  // Parse the JSON response from Koios API
  var responseData = JSON.parse(koiosResponse.getContentText());
  var stakeInfo = responseData[0];

  // Extract relevant information from Koios API response
   totalBalance = Math.round(parseFloat(stakeInfo.total_balance) * 1e-6);
  var rewards = Math.round(parseFloat(stakeInfo.rewards) * 1e-6);
  var withdrawals = Math.round(parseFloat(stakeInfo.withdrawals) * 1e-6);
  var rewardsAvailable = Math.round(parseFloat(stakeInfo.rewards_available) * 1e-6);
  var emoji = "\uD83D\uDE04"; // Emoticon '😄'
  var poolid = stakeInfo.delegated_pool;

    // Logger.log giá trị của totalbalance
    

    // Thêm dữ liệu vào Google Sheet
    appendDataToSheet(totalBalance);

   
  }
  

function appendDataToSheet(totalBalance) {
  // Lấy ra bảng tính dựa trên ID
  var spreadsheet = SpreadsheetApp.openById(spreadsheetId);

  // Chọn sheet (nếu có nhiều sheet)
  var sheet = spreadsheet.getSheetByName("Tonghop"); // Thay "Sheet1" bằng tên của sheet trong bảng tính của bạn

  // Tạo một mảng dữ liệu để thêm vào sheet
  var data = [new Date(), totalBalance]; // Assuming you want to append the date and totalbalance

  // Thêm mảng dữ liệu vào sheet
  sheet.appendRow(data);

  console.log("Data appended to the sheet:", data);
}
function getDataFromSheet() {
  try {
    var spreadsheet = SpreadsheetApp.openById(spreadsheetId);
    var sheet = spreadsheet.getSheetByName("sheetname do bạn tạo trong googlesheet");

    // Check if the sheet exists
    if (!sheet) {
      console.error(" 'sheetname' not found in the spreadsheet.");
      return null;
    }

    // Check if there is data in the sheet
    var lastRow = sheet.getLastRow();
    if (lastRow < 2) {
      console.error("No data found in the sheet.");
      return null;
    }

    // Lấy dữ liệu từ cột B (Giả định totalbalance là cột B, chỉnh lại nếu cần thiết theo ý thích)
    var data = sheet.getRange(1, 2, sheet.getLastRow(), 1).getValues();
    return data;
  } catch (error) {
    console.error("Error accessing the spreadsheet:", error);
    return null;
  }
}

function compareAndPrintResults() {

  var sheetName = "tên sheetname";
  var check = "https://adastat.net/accounts/..."
  var sheet = SpreadsheetApp.openById(spreadsheetId).getSheetByName(sheetName);
  var data = sheet.getDataRange().getValues();

  var message = ""; // Initialize an empty message

  // Get the values for the latest row
  var latestRow = data.length;
  var currentValue = data[latestRow - 1][1]; // Assuming values are in column B

  // Compare with the previous row
  if (latestRow > 1) {
    var previousValue = data[latestRow - 2][1];
    var result = currentValue - previousValue;
        // Store the result in column C of the latest row
      sheet.getRange("C" + latestRow).setValue(result);

    if (result >0) { // Append to the message
      message += "\n" ;
      message += "<b> Ví của bạn vừa tăng thêm " + result + " ADA  </b>\n";
      message += "\n" ;
      message += "<b> Tổng số dư hiện tại là " + currentValue + "ADA </b>\n";
      message += " Kiểm tra giao dịch ở đây nhé" + check + "\n";
      message += "Thời gian kiểm tra thực tế: " + currentTime + "\n";

      sendTelegramMessageToGroup(telegramBotToken, telegramChatId, message)
    } else if (result < 0) {
      message += "\n" ;
      message += "<b> Ví của bạn vừa giảm đi " + result + " ADA  </b>\n";
      message += "\n" ;
      message += "<b> Tổng số dư hiện tại là " + currentValue + " ADA </b>\n";
      message += " Kiểm tra giao dịch ở đây nhé" + check + "\n";
      message += "Thời gian kiểm tra thực tế: " + currentTime + "\n";
      sendTelegramMessageToGroup(telegramBotToken, telegramChatId, message)
    }
  }
  var emailSubject = "Thông tin sếp";
if (message.trim() !== "") {
  MailApp.sendEmail({
    to: recipientEmail,
    subject: emailSubject,
    htmlBody: message
  });

  // Print the final message to the console
  console.log("Comparison completed:\n" + message);
} else {
  console.log("Message is empty. Not sending the email.");
}
}


function sendTelegramMessageToGroup(telegramBotToken, telegramChatId, message) {
  if (message.trim() !== "") {  // Check if the message is not empty or just whitespace
 

    var telegramApiUrl = "https://api.telegram.org/bot" + telegramBotToken + "/sendMessage";

    var payload = {
      "chat_id": telegramChatId,
      "text": message,
      "parse_mode": "HTML"
    };

    // Make the HTTP request to send the message
    var response = UrlFetchApp.fetch(telegramApiUrl, {
      "method": "post",
      "contentType": "application/json",
      "payload": JSON.stringify(payload)
    });

    // Log the response to check for errors
    console.log(response.getContentText());
  } else {
    console.log("Message is empty. Not sending to Telegram.");
  }
}

// Lấy dữ liệu từ sheet
var sheetData = getDataFromSheet();

// So sánh và gửi thông báo nếu có thay đổi
compareAndPrintResults(sheetData);

function account_info(){

var url1 = 'https://api.koios.rest/api/v1/account_info';
var url2 = 'https://api.koios.rest/api/v1/account_assets';

var headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
};

var payload = {
  '_stake_addresses': ["stakekey của bạn"]
};

var options = {
  'method': 'post',
  'headers': headers,
  'payload': JSON.stringify(payload)
};

var responseurl1 = UrlFetchApp.fetch(url1, options);
var responseurl2 = UrlFetchApp.fetch(url2, options);

  // Chuyển đổi phản hồi từ API sang đối tượng JSON
var data1 = JSON.parse(responseurl1.getContentText())[0];
var data2 = JSON.parse(responseurl2.getContentText());
  // Lấy kết quả stake_address từ phản hồi API
var adabal = Math.round(parseFloat(data1.total_balance) * 1e-6);
var asset_info = [];
for (var i = 0; i < data2.length; i++) {
  var assetName = data2[i].asset_name;
  var quantity = data2[i].quantity;
  var decimal = data2[i].decimals;

  // Chuyển đổi assetName thành chuỗi ASCII
  var asciiAssetName = convertHexToASCII(assetName);

  // Thêm vào mảng values để sau đó ghi vào Google Sheets
  asset_info.push([asciiAssetName, quantity, decimal]);
}

  // Lọc và trả kết quả từ bảng "tonghop"
var spreadsheet1 = SpreadsheetApp.openById(spreadsheetId);

  // Chọn sheet (nếu có nhiều sheet)
var sheet1 = spreadsheet1.getSheetByName("live"); // Thay "Sheet1" bằng tên của sheet trong bảng tính của bạn
sheet1.clear();
sheet1.getRange(1, 1).setValue("ADA");
sheet1.getRange(2, 1).setValue(adabal);

if (asset_info.length > 0) {
  // Ghi asset_name vào hàng đầu tiên, bắt đầu từ cột 2
  for (var i = 0; i < asset_info.length; i++) {
    sheet1.getRange(1, i + 2).setValue(asset_info[i][0]);
  }

  // Ghi quantity vào hàng thứ hai, bắt đầu từ cột 2
  for (var i = 0; i < asset_info.length; i++) {
    sheet1.getRange(2, i + 2).setValue(asset_info[i][1]);
  }
  // Ghi decimals vào hàng thứ ba, bắt đầu từ cột 2
  for (var i = 0; i < asset_info.length; i++) {
    sheet1.getRange(3, i + 2).setValue(asset_info[i][2]);
  }
  Logger.log(adabal);
} else {
  Logger.log("Không có dữ liệu asset_info để ghi vào sheet.");
}
  var dataRange = sheet1.getDataRange();
  var values = dataRange.getValues();
  
  // Check if there is any data
  if (values.length > 1) {
    var message = "<b>Thông tin tài khoản của bạn</b>\n\n";
    var assetNameColumn = values[0];
    var quantityColumn = values[1];
    var decimalColumn = values[2];
    var message1 ="";
    // Iterate through each item in the column
    for (var i = 0; i < assetNameColumn.length; i++) {
      var assetName = assetNameColumn[i];
      var quantity = quantityColumn[i];
      var decimal = decimalColumn[i]
      if (decimal > 0) {
          quantity = quantity * Math.pow(10, -decimal);
        }

      // Append assetName and quantity to the message as a list item
      message1 += `-  ${assetName} : <b> ${quantity} </b>\n`;
    }
      message1 += `\nThời gian kiểm tra thực tế: ` + currentTime + '\n';
      message1 += `Cảm ơn sếp đã luôn ủng hộ VIET pool\n `;
     
      
    
    var finalmess = message + message1;

    // Send the constructed message
    sendTelegramMessageToGroup(telegramBotToken, telegramChatId, finalmess);
    var emailSubject = "Thông tin sếp";
    if (message.trim() !== "") {
    MailApp.sendEmail({
      to: recipientEmail,
      subject: emailSubject,
      htmlBody: finalmess
    });
    }
    }else {
    // Inform the user if there is no data
    send("Không có thông tin về ví.", telegramChatId);
  }

}

function convertHexToASCII(hexString) {
  try {
    // Convert hex to bytes
    var bytes = [];
    for (var i = 0; i < hexString.length; i += 2) {
      bytes.push(parseInt(hexString.substr(i, 2), 16));
    }

    // Create a blob from the bytes
    var blob = Utilities.newBlob(bytes);

    // Convert the blob to ASCII string
    var asciiString = blob.getDataAsString();

    Logger.log("Converted ASCII String: " + asciiString);
    return asciiString;
  } catch (error) {
    Logger.log("Error converting hex to ASCII: " + error);
    return null; // Return null if there's an error
  }
  }
function getCurrentTime() {
  var currentTime = new Date();
  var hours = currentTime.getHours();
  var minutes = currentTime.getMinutes();
  var seconds = currentTime.getSeconds();
  var day = currentTime.getDate();
  var month = currentTime.getMonth() + 1; // Tháng bắt đầu từ 0
  var year = currentTime.getFullYear();

  // Đảm bảo rằng các giá trị nhỏ hơn 10 được hiển thị với hai chữ số
  if (hours < 10) {
    hours = '0' + hours;
  }
  if (minutes < 10) {
    minutes = '0' + minutes;
  }
  if (seconds < 10) {
    seconds = '0' + seconds;
  }
  if (day < 10) {
    day = '0' + day;
  }
  if (month < 10) {
    month = '0' + month;
  }

  // Trả về chuỗi biểu diễn cho thời gian hiện tại
  return hours + ':' + minutes + ':' + seconds + ' ' + day + '/' + month + '/' + year;
}
function appendDataToSheet(totalBalance) {
  // Lấy ra bảng tính dựa trên ID
  var spreadsheet = SpreadsheetApp.openById(spreadsheetId);

  // Chọn sheet (nếu có nhiều sheet)
  var sheet = spreadsheet.getSheetByName("Tonghop"); // Thay "Sheet1" bằng tên của sheet trong bảng tính của bạn

  // Tạo một mảng dữ liệu để thêm vào sheet
  var data = [new Date(), totalBalance]; // Assuming you want to append the date and totalbalance

  // Thêm mảng dữ liệu vào sheet
  sheet.appendRow(data);

  console.log("Data appended to the sheet:", data);
}





Функция ПараметыЧекаТранзита(ВыдачаТранзита) Экспорт
	
	
	
	ПолучателиПисьма				= Новый Массив;
	
	новыйПолучатель 				= Новый Структура("Адрес, Представление, ИсточникКонтактнойИнформации");
	новыйПолучатель.Адрес 			= ВыдачаТранзита.ТочкаНазначения.Майл;;
	новыйПолучатель.Представление 	= ВыдачаТранзита.ТочкаНазначения.Наименование;
	новыйПолучатель.ИсточникКонтактнойИнформации = ВыдачаТранзита.ТочкаНазначения;
	ПолучателиПисьма.Добавить(новыйПолучатель);
	
	
	доки = новый массив;
	доки.Добавить(ВыдачаТранзита);
	табДокЧекка = Документы.ВыдачаТранзита.Печать_ЧекСИтогамиПоГабаритам(доки,Неопределено);
	
	имяФайлаВложения = ПолучитьИмяВременногоФайла("xls");
	табДокЧекка.Записать(имяФайлаВложения,ТипФайлаТабличногоДокумента.XLS);
	АдресВоВременномХранилище =ПоместитьВоВременноеХранилище(новый ДвоичныеДанные(имяФайлаВложения));;
	
	ТемаПисьма =ВыдачаТранзита.ТочкаОтправитель.Наименование+ " Транзит №"+ ВыдачаТранзита.Номер+" от "+Формат(ВыдачаТранзита.дата,"ДФ=dd.MM.yyyy");
	
	
	чек = Новый Структура;
	чек.Вставить("Представление", "Транзит №"+ ВыдачаТранзита.Номер+" от "+Формат(ВыдачаТранзита.дата,"ДФ=dd.MM.yyyy")+"_" +ВыдачаТранзита.ТочкаОтправитель+".xls");
	чек.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	
	Вложения = Новый Массив;
	Вложения.Добавить(чек);
	
	ПарамтерыОтправления = Новый Структура;
	ПарамтерыОтправления.Вставить("Кому", 		ПолучателиПисьма);
	ПарамтерыОтправления.Вставить("Получатель", ПолучателиПисьма);
	ПарамтерыОтправления.Вставить("Предмет", 	ВыдачаТранзита);
	ПарамтерыОтправления.Вставить("Тема", 		ТемаПисьма);
	ПарамтерыОтправления.Вставить("Тело", 		ТемаПисьма);
	ПарамтерыОтправления.Вставить("Вложения",	Вложения);
	
	Возврат ПарамтерыОтправления;
	
КонецФункции

Функция ПараметыЧекаРасходной(Расходная) Экспорт
	
	
	
	ПолучателиПисьма				= Новый Массив;
	
	новыйПолучатель 				= Новый Структура("Адрес, Представление, ИсточникКонтактнойИнформации");
	новыйПолучатель.Адрес 			= Расходная.Ответственный.ЕМайл;;
	новыйПолучатель.Представление 	= Расходная.Ответственный.Наименование;
	новыйПолучатель.ИсточникКонтактнойИнформации = Расходная.Ответственный;
	ПолучателиПисьма.Добавить(новыйПолучатель);
	
	
	доки = новый массив;
	доки.Добавить(Расходная);
	табДокЧекка = Документы.Расходная.СписокЗаказов(доки,Неопределено);
	
	имяФайлаВложения = ПолучитьИмяВременногоФайла("PDF");
	табДокЧекка.Записать(имяФайлаВложения,ТипФайлаТабличногоДокумента.PDF);
	АдресВоВременномХранилище =ПоместитьВоВременноеХранилище(новый ДвоичныеДанные(имяФайлаВложения));;
	
	ТемаПисьма =Расходная.Участник.Наименование+ " Чек №"+ Расходная.Номер+" от "+Формат(Расходная.дата,"ДФ=dd.MM.yyyy");
	
	
	чек = Новый Структура;
	чек.Вставить("Представление", "Чек №"+ Расходная.Номер+" от "+Формат(Расходная.дата,"ДФ=dd.MM.yyyy")+"_" +Расходная.Участник+".PDF");
	чек.Вставить("АдресВоВременномХранилище", АдресВоВременномХранилище);
	
	Вложения = Новый Массив;
	Вложения.Добавить(чек);
	
	ПарамтерыОтправления = Новый Структура;
	ПарамтерыОтправления.Вставить("Кому", 		ПолучателиПисьма);
	ПарамтерыОтправления.Вставить("Получатель", ПолучателиПисьма);
	ПарамтерыОтправления.Вставить("Предмет", 	Расходная);
	ПарамтерыОтправления.Вставить("Тема", 		ТемаПисьма);
	ПарамтерыОтправления.Вставить("Тело", 		ТемаПисьма);
	ПарамтерыОтправления.Вставить("Вложения",	Вложения);
	
	Возврат ПарамтерыОтправления;
	
КонецФункции


Функция ОтправитьЧекТранзита(ВыдачаТранзита) Экспорт
	
	
	УчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
	ПарамтерыОтправления = ПараметыЧекаТранзита(ВыдачаТранзита);
	
	РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись,ПарамтерыОтправления);
	
	
КонецФункции	


Функция ОтправитьЧекРасходной(Расходная) Экспорт
	Если Расходная.Ответственный.ОтправлятьЧекСотруднику и 
		ЗначениеЗаполнено(Расходная.Ответственный.ЕМайл) Тогда
		
		УчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
		ПарамтерыОтправления = ПараметыЧекаРасходной(Расходная);
		
		РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись,ПарамтерыОтправления);
	КонецЕсли;
	
КонецФункции	
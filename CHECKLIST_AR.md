# قائمة فحص قبل التشغيل

1. لديك موافقة مكتوبة من Heroku لهذا التطبيق تحديداً.
2. اسم التطبيق في `config.env` هو `afdaa` أو اسم تطبيقك الصحيح.
3. وضعت عنوان XMR في `XMR_WALLET` داخل `config.env`.
4. لا تضع Seed Phrase أو Private Key في أي ملف.
5. شغّلت `heroku stack:set container -a afdaa` أو تركت `deploy.sh` ينفذها تلقائياً.
6. بعد النشر شغّلت worker عبر `heroku ps:scale worker=1 -a afdaa`.
7. في السجل يجب أن تظهر كلمة `accepted` حتى تتأكد أن الـ Pool يقبل التعدين.

إذا ظهر خطأ `No default language could be detected` فهذا يعني أن التطبيق ليس على stack container، وشغّل:

```bash
heroku stack:set container -a afdaa
```

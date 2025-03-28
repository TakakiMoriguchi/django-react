from django.urls import path
from django.conf import settings
from django.conf.urls.static import static
from . import views
from django.contrib import admin
from django.urls import path, include
from django.views.generic import TemplateView

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('app.urls')),  # APIエンドポイント
    path('', TemplateView.as_view(template_name='index.html')),  # Reactアプリのエントリーポイント
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

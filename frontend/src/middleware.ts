import { NextRequest, NextResponse } from "next/server";

export default async function middleware(req: NextRequest) {
  const url = req.nextUrl.clone()

  if(req.cookies.has('refresh_token')) {
    const unprotectedRoutes = [
      '/',
      '/sign_in',
      '/sign_up'
    ]
    if (unprotectedRoutes.includes(url.pathname)) {
      url.pathname = "/dashboard"
      return NextResponse.redirect(url)
    }
  } else {
    const protectedRoutes = [
      '/'
    ]
    if (protectedRoutes.includes(url.pathname)) {
      url.pathname = "/sign_in"
      return NextResponse.redirect(url)
    }
  }

  return NextResponse.rewrite(url)
}

export const config = {
  matcher: [
    /*
     * Match all request paths except for the ones starting with:
     * - api (API routes)
     * - _next/static (static files)
     * - _next/image (image optimization files)
     * - favicon.ico (favicon file)
     */
    '/((?!api|_next/static|_next/image|favicon.ico).*)',
  ],
}